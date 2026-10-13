import struct, zlib, os, sys

HOME = os.path.expanduser("~")
SRC = os.path.join(HOME, "原神7.1重定向代理/原神_7.1.0_48052158_48145775_clone.apk")
OUT = os.path.join(HOME, "apk_out/原神_7.1.0_redirect2_unsigned.apk")
REPL = {
    "assets/bin/Data/07134351e12778a4d9c727bb286b16c8": os.path.join(HOME, "apk_out/07134351e12778a4d9c727bb286b16c8"),
    "classes3.dex": os.path.join(HOME, "apk_out/classes3_new.dex"),
    "classes4.dex": os.path.join(HOME, "apk_out/classes4_new.dex"),
}

newdata = {}
for k, v in REPL.items():
    with open(v, "rb") as f:
        newdata[k] = f.read()
    print("patch %-52s %d bytes" % (k, len(newdata[k])))


def find_eocd(f):
    f.seek(0, 2)
    size = f.tell()
    back = min(size, 65557)
    f.seek(size - back)
    buf = f.read(back)
    idx = buf.rfind(b"PK\x05\x06")
    if idx < 0:
        raise RuntimeError("no EOCD")
    return size - back + idx, size


def main():
    fin = open(SRC, "rb")
    eocd_off, file_size = find_eocd(fin)
    fin.seek(eocd_off)
    eocd = fin.read(22)
    (sig, disk, cd_disk, n_this, n_total, cd_size, cd_off, com_len) = struct.unpack("<IHHHHIIH", eocd)
    assert sig == 0x06054b50
    print("EOCD: cd_off=%d cd_size=%d total=%d comment=%d" % (cd_off, cd_size, n_total, com_len))

    fin.seek(cd_off)
    cd = fin.read(cd_size)

    entries = []
    p = 0
    while p < len(cd):
        assert cd[p:p + 4] == b"PK\x01\x02", "bad central sig at %d" % p
        (sigc, vmade, vneed, flags, method, mtime, mdate, crc, comp, uncomp,
         fnl, exl, cml, dstart, iattr, eattr, loff) = struct.unpack("<IHHHHHHIIIHHHHHII", cd[p:p + 46])
        name = cd[p + 46:p + 46 + fnl]
        rec_len = 46 + fnl + exl + cml
        entries.append({
            "raw": cd[p:p + rec_len], "name": name, "flags": flags, "method": method,
            "crc": crc, "comp": comp, "uncomp": uncomp, "loff": loff,
            "fnl": fnl, "exl": exl,
        })
        p += rec_len
    print("parsed %d central records, consumed %d/%d" % (len(entries), p, len(cd)))

    fout = open(OUT, "wb")
    new_offsets = []
    changed = 0
    for e in entries:
        name = e["name"].decode("utf-8", "replace")
        is_changed = name in REPL
        fin.seek(e["loff"])
        lh = fin.read(30)
        (lsig, lvneed, lflags, lmethod, ltime, ldate, lcrc, lcomp, luncomp, lfnl, lexl) = struct.unpack("<IHHHHHIIIHH", lh)
        assert lsig == 0x04034b50, "bad local sig for %s" % name
        new_off = fout.tell()
        new_offsets.append(new_off)

        if not is_changed:
            fin.seek(e["loff"])
            remain = 30 + lfnl + lexl + e["comp"]
            while remain > 0:
                chunk = fin.read(min(1 << 20, remain))
                if not chunk:
                    raise RuntimeError("eof copying %s" % name)
                fout.write(chunk)
                remain -= len(chunk)
        else:
            data = newdata[name]
            crc = zlib.crc32(data) & 0xffffffff
            co = zlib.compressobj(9, zlib.DEFLATED, -15)
            comp_data = co.compress(data) + co.flush()
            fname = e["name"]
            fin.seek(e["loff"] + 30 + lfnl)
            lextra = fin.read(lexl)
            flags = lflags & ~0x08
            hdr = struct.pack("<IHHHHHIIIHH", 0x04034b50, lvneed, flags, 8, ltime, ldate,
                              crc, len(comp_data), len(data), lfnl, lexl)
            fout.write(hdr); fout.write(fname); fout.write(lextra); fout.write(comp_data)
            e["_newcrc"] = crc
            e["_newcomp"] = len(comp_data)
            e["_newuncomp"] = len(data)
            changed += 1
            print("  replaced %-52s %d -> %d bytes (comp %d -> %d)" % (name, e["uncomp"], len(data), e["comp"], len(comp_data)))

    cd_new_off = fout.tell()
    for e, noff in zip(entries, new_offsets):
        rec = bytearray(e["raw"])
        struct.pack_into("<I", rec, 42, noff)
        if "_newcrc" in e:
            struct.pack_into("<I", rec, 16, e["_newcrc"])
            struct.pack_into("<I", rec, 20, e["_newcomp"])
            struct.pack_into("<I", rec, 24, e["_newuncomp"])
            struct.pack_into("<H", rec, 8, e["flags"] & ~0x08)
        fout.write(rec)
    cd_new_size = fout.tell() - cd_new_off

    fin.seek(eocd_off + 22)
    comment = fin.read(com_len)
    ne = bytearray(eocd)
    struct.pack_into("<I", ne, 12, cd_new_size)
    struct.pack_into("<I", ne, 16, cd_new_off)
    fout.write(ne); fout.write(comment)

    fout.close(); fin.close()
    print("changed=%d  out=%s  size=%d (orig %d)" % (changed, OUT, os.path.getsize(OUT), file_size))


if __name__ == "__main__":
    main()
