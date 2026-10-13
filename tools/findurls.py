import urllib.request, struct, zlib, sys, re

URL = "https://github.com/Pape7rlane/smartphones-and-tricks/releases/download/1/yuanshen_7.1.0.apk"
NEEDLES = [b"yuanshen.com", b"dispatch", b"hk4e", b"mihoyo.com", b"query_region_list",
           b"query_cur_region", b"dispatchcnglobal", b"cngfdispatch", b"autopatchcn",
           b"ysdownload", b"hoyoverse", b"http://", b"https://"]

def get_range(start, end, tries=3):
    for _ in range(tries):
        try:
            req = urllib.request.Request(URL, headers={"Range": f"bytes={start}-{end}", "User-Agent": "curl/8"})
            with urllib.request.urlopen(req, timeout=180) as r:
                return r.read()
        except Exception as e:
            print("retry", e, file=sys.stderr)
    raise RuntimeError("range fail")

req = urllib.request.Request(URL, method="HEAD")
with urllib.request.urlopen(req, timeout=60) as r:
    size = int(r.headers["Content-Length"])

tail = get_range(size - 1024 * 1024, size - 1)
idx = tail.rfind(b"PK\x05\x06")
eocd = tail[idx:idx + 22]
cd_size, cd_off = struct.unpack("<II", eocd[12:20])
cd = get_range(cd_off, cd_off + cd_size - 1)
entries = {}
i = 0
while i + 46 <= len(cd):
    if cd[i:i + 4] != b"PK\x01\x02":
        break
    nlen = struct.unpack("<H", cd[i + 28:i + 30])[0]
    elen = struct.unpack("<H", cd[i + 30:i + 32])[0]
    clen = struct.unpack("<H", cd[i + 32:i + 34])[0]
    csize = struct.unpack("<I", cd[i + 20:i + 24])[0]
    usize = struct.unpack("<I", cd[i + 24:i + 28])[0]
    method = struct.unpack("<H", cd[i + 10:i + 12])[0]
    lho = struct.unpack("<I", cd[i + 42:i + 46])[0]
    name = cd[i + 46:i + 46 + nlen].decode("utf-8", "replace")
    entries[name] = (lho, csize, usize, method)
    i += 46 + nlen + elen + clen

def data_start(name):
    lho, csize, usize, method = entries[name]
    hdr = get_range(lho, lho + 29)
    nlen = struct.unpack("<H", hdr[26:28])[0]
    elen = struct.unpack("<H", hdr[28:30])[0]
    return lho + 30 + nlen + elen, csize, usize, method

def scan_bytes(name, blob):
    hits = {}
    for nd in NEEDLES:
        pos = 0
        locs = []
        while True:
            p = blob.find(nd, pos)
            if p < 0:
                break
            locs.append(p)
            pos = p + 1
            if len(locs) > 20:
                break
        if locs:
            hits[nd.decode()] = locs
    return hits

# 1) small/medium files: dex + small so + configs
targets = [n for n in entries if n.endswith(".dex")]
targets += [n for n in entries if n.endswith(".so") and entries[n][2] < 6_000_000]
targets += [n for n in entries if n.endswith(".json") or n.endswith(".config") or "metadata" in n.lower()]
print("== scanning", len(targets), "small files ==")
for name in sorted(set(targets)):
    dstart, csize, usize, method = data_start(name)
    raw = get_range(dstart, dstart + csize - 1)
    if method == 8:
        try:
            raw = zlib.decompress(raw, -15)
        except Exception as e:
            print(name, "decompress err", e); continue
    hits = scan_bytes(name, raw)
    if hits:
        print(f"\n### {name} (usize={usize})")
        for k, v in hits.items():
            print("   ", k, v[:10])
        # show context around first yuanshen.com/dispatch hit
        for nd in (b"yuanshen.com", b"dispatch", b"mihoyo.com"):
            p = raw.find(nd)
            if p >= 0:
                print("    ctx:", raw[max(0, p - 60):p + 80])
