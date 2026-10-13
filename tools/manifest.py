import urllib.request, struct, re

URL = "https://github.com/Pape7rlane/smartphones-and-tricks/releases/download/1/yuanshen_7.1.0.apk"

def get_range(start, end):
    req = urllib.request.Request(URL, headers={"Range": f"bytes={start}-{end}", "User-Agent": "curl/8"})
    with urllib.request.urlopen(req, timeout=180) as r:
        return r.read()

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
    method = struct.unpack("<H", cd[i + 10:i + 12])[0]
    lho = struct.unpack("<I", cd[i + 42:i + 46])[0]
    name = cd[i + 46:i + 46 + nlen].decode("utf-8", "replace")
    entries[name] = (lho, csize, method)
    i += 46 + nlen + elen + clen

def fetch_entry(name):
    lho, csize, method = entries[name]
    hdr = get_range(lho, lho + 29)
    nlen = struct.unpack("<H", hdr[26:28])[0]
    elen = struct.unpack("<H", hdr[28:30])[0]
    dstart = lho + 30 + nlen + elen
    raw = get_range(dstart, dstart + csize - 1)
    if method == 8:
        import zlib
        raw = zlib.decompress(raw, -15)
    return raw

d = fetch_entry("AndroidManifest.xml")
print("manifest bytes:", len(d))
strs = re.findall(rb"[\x20-\x7e]{4,}", d)
print("string count:", len(strs))
print("--- interesting ---")
seen = set()
for s in strs:
    t = s.decode()
    if t in seen:
        continue
    seen.add(t)
    tl = t.lower()
    if any(k in tl for k in ["http", "mihoyo", "yuanshen", "hoyo", "bh4", "hk4e", "dispatch",
                             "permission.", "android.intent", "activity", "provider", "service",
                             "android:name", "package="]):
        print(t)
