import urllib.request, struct, sys

URL = "https://github.com/Pape7rlane/smartphones-and-tricks/releases/download/1/yuanshen_7.1.0.apk"

def get_range(start, end):
    req = urllib.request.Request(URL, headers={"Range": f"bytes={start}-{end}", "User-Agent": "curl/8"})
    with urllib.request.urlopen(req, timeout=120) as r:
        return r.read(), r.headers.get("Content-Range"), r.status

req = urllib.request.Request(URL, method="HEAD")
with urllib.request.urlopen(req, timeout=60) as r:
    size = int(r.headers["Content-Length"])
print("size:", size)

tail_start = size - 1024 * 1024
data, cr, st = get_range(tail_start, size - 1)
print("range resp:", st, cr, "got", len(data))

idx = data.rfind(b"PK\x05\x06")
print("EOCD at tail offset:", idx)
if idx < 0:
    sys.exit("no EOCD")
eocd = data[idx:idx + 22]
cd_size, cd_off = struct.unpack("<II", eocd[12:20])
print("central dir size:", cd_size, "offset:", cd_off)

# fetch central directory
cd, cr2, st2 = get_range(cd_off, cd_off + cd_size - 1)
print("cd fetch:", st2, cr2, "got", len(cd))

names = []
i = 0
while i + 46 <= len(cd):
    if cd[i:i + 4] != b"PK\x01\x02":
        break
    nlen = struct.unpack("<H", cd[i + 28:i + 30])[0]
    elen = struct.unpack("<H", cd[i + 30:i + 32])[0]
    clen = struct.unpack("<H", cd[i + 32:i + 34])[0]
    csize = struct.unpack("<I", cd[i + 20:i + 24])[0]
    usize = struct.unpack("<I", cd[i + 24:i + 28])[0]
    name = cd[i + 46:i + 46 + nlen].decode("utf-8", "replace")
    names.append((name, csize, usize))
    i += 46 + nlen + elen + clen

print("entries:", len(names))
import collections
top = collections.Counter()
for n, cs, us in names:
    top[n.split("/")[0]] += 1
print("=== top-level ===")
for k, v in top.most_common(40):
    print(f"{v:6d}  {k}")

print("=== key entries ===")
for n, cs, us in names:
    low = n.lower()
    if (low.endswith(".dex") or low.endswith("androidmanifest.xml") or "lib/" in low and low.endswith(".so")
            or low.startswith("assets/") or "mihoyo" in low or "yuanshen" in low or "dispatch" in low):
        print(f"{us:12d}  {n}")
PY
