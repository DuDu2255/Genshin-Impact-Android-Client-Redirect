import urllib.request, struct, sys, re

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
    usize = struct.unpack("<I", cd[i + 24:i + 28])[0]
    method = struct.unpack("<H", cd[i + 10:i + 12])[0]
    lho = struct.unpack("<I", cd[i + 42:i + 46])[0]
    name = cd[i + 46:i + 46 + nlen].decode("utf-8", "replace")
    entries[name] = (lho, csize, usize, method)
    i += 46 + nlen + elen + clen

def fetch_entry(name):
    lho, csize, usize, method = entries[name]
    hdr = get_range(lho, lho + 29)
    nlen = struct.unpack("<H", hdr[26:28])[0]
    elen = struct.unpack("<H", hdr[28:30])[0]
    dstart = lho + 30 + nlen + elen
    raw = get_range(dstart, dstart + csize - 1)
    if method == 8:
        import zlib
        raw = zlib.decompress(raw, -15)
    return raw

# small config files
for n in ["assets/assets_config.json", "assets/asb_settings.json",
          "assets/Persistent/plugindelayed.config", "assets/bid-log-key-public.key",
          "assets/AssetBundles/data_revision", "assets/AssetBundles/res_revision",
          "assets/AssetBundles/silence_revision", "apm-versions", "versions"]:
    if n in entries:
        try:
            d = fetch_entry(n)
            print(f"===== {n} ({len(d)}B) =====")
            print(d[:1500].decode("utf-8", "replace"))
            print()
        except Exception as e:
            print(n, "ERR", e)

# manifest strings
if "AndroidManifest.xml" in entries:
    d = fetch_entry("AndroidManifest.xml")
    print(f"===== AndroidManifest.xml ({len(d)}B) =====")
    strs = re.findall(rb"[\x20-\x7e]{5,}", d)
    seen = set()
    for s in strs:
        t = s.decode()
        if t not in seen:
            seen.add(t)
            if any(k in t.lower() for k in ["http", "mihoyo", "yuanshen", "hoyoverse", "com.", "permission", "activity", "service", "provider"]):
                print(t)
PY