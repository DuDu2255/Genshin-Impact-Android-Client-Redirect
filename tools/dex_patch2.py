import struct, zlib, hashlib, zipfile, re, os

HOME = os.path.expanduser("~")
APK = os.path.join(HOME, "原神7.1重定向代理/原神_7.1.0_48052158_48145775_clone.apk")
OUTDIR = os.path.join(HOME, "apk_out")
LOCAL = b"http://127.0.0.1:10086"

# 只匹配整条 URL（https://<sub>.mihoyo.com[/path]）
pat = re.compile(rb'^https://[^/]*\.(?:mihoyo|hoyoverse)\.com(/.*)?$')


def uleb_nbytes(n):
    c = 1
    while n >= 0x80:
        n >>= 7
        c += 1
    return c


def read_uleb(d, o):
    n = 0
    sh = 0
    p = o
    while True:
        b = d[p]
        p += 1
        n |= (b & 0x7f) << sh
        if not (b & 0x80):
            break
        sh += 7
    return n, p


def pad_to(new, target, path):
    """把 new 补到恰好 target 字节，且保持语义安全：
    http://<pad>@127.0.0.1:10086<path>
    host 仍是 127.0.0.1，userinfo 被忽略；基址拼路径也安全。
    长度：7 + (need-1) + 1 + 15 + len(path) = 22 + need + len(path) == target"""
    need = target - len(new)
    if need <= 0:
        return new, need < 0
    return b'http://' + b'0' * (need - 1) + b'@127.0.0.1:10086' + path, False


def patch_dex(raw, label):
    d = bytearray(raw)
    (magic, ck, sig, fs, hs, et, ls, lo, mo, sis, sio, tis, tio, pis, pio,
     fis, fio, mis, mio, cds, cdo, ds, do) = struct.unpack("<8sI20s20I", bytes(d[:112]))
    offs = list(struct.unpack("<%dI" % sis, bytes(d[sio:sio + 4 * sis])))
    changed = 0
    skipped = 0
    bad = 0
    warned = 0
    for idx, o in enumerate(offs):
        n, p = read_uleb(d, o)
        ub = p - o                      # uleb 字节数
        content = bytes(d[p:p + n])
        m = pat.match(content)
        if not m:
            continue
        path = m.group(1) or b''
        new = LOCAL + path
        if len(new) > n:
            skipped += 1
            continue
        new, warn = pad_to(new, n, path)
        if warn:
            warned += 1
            print("   WARN need=1 no-fragment:", content[:60])
        # 长度必须完全一致，uleb 字节数也必须一致
        if len(new) != n or uleb_nbytes(n) != ub:
            bad += 1
            continue
        d[p:p + n] = new
        changed += 1
    d[0x0c:0x20] = hashlib.sha1(bytes(d[0x20:])).digest()
    d[0x08:0x0c] = struct.pack("<I", zlib.adler32(bytes(d[0x0c:])) & 0xffffffff)
    print("[%s] changed=%d skipped=%d bad=%d warned=%d" % (label, changed, skipped, bad, warned))
    return bytes(d)


def verify_no_gap(raw, label):
    d = raw
    (magic, ck, sig, fs, hs, et, ls, lo, mo, sis, sio, tis, tio, pis, pio,
     fis, fio, mis, mio, cds, cdo, ds, do) = struct.unpack("<8sI20s20I", d[:112])
    offs = sorted(set(struct.unpack("<%dI" % sis, d[sio:sio + 4 * sis])))
    items = []
    for o in offs:
        n, p = read_uleb(d, o)
        # 计算 MUTF-8 字节数：按 UTF-16 码元数 n 走
        cnt = 0
        q = p
        while cnt < n:
            b = d[q]
            if b == 0:
                break
            if (b & 0xC0) != 0x80:
                cnt += 1
            q += 1
        items.append((o, q + 1))
    items.sort()
    gaps = [items[k][0] - items[k - 1][1] for k in range(1, len(items)) if items[k][0] != items[k - 1][1]]
    print("[%s] 字符串项=%d 空隙=%d %s" % (label, len(items), len(gaps), gaps[:8]))


if __name__ == "__main__":
    z = zipfile.ZipFile(APK)
    for dn in ["classes3.dex", "classes4.dex"]:
        raw = z.read(dn)
        out = patch_dex(raw, dn)
        verify_no_gap(raw, "ORIG " + dn)
        verify_no_gap(out, "NEW  " + dn)
        with open(os.path.join(OUTDIR, dn), "wb") as f:
            f.write(out)
        print("  wrote", os.path.join(OUTDIR, dn), len(out))
