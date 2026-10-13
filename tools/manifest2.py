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

d = fetch_entry("AndroidManifest.xml")
print("manifest bytes:", len(d), "magic:", d[:4].hex())

# AXML string pool parser
def parse_axml_strings(data):
    # header
    if data[:2] != b"\x03\x00":
        return None
    # string pool chunk
    off = 8
    typ, hsize, csize = struct.unpack("<HHI", data[off:off + 8])
    if typ != 0x0001:
        return None
    string_count, style_count, flags, strings_start, styles_start = struct.unpack("<IIIII", data[off + 8:off + 28])
    utf8 = bool(flags & (1 << 8))
    offsets = struct.unpack("<%dI" % string_count, data[off + 28:off + 28 + 4 * string_count])
    base = off + strings_start
    out = []
    for o in offsets:
        p = base + o
        if utf8:
            # u16 len (utf16 chars), u8 len (utf8 bytes)
            n = data[p]
            p += 1
            if n & 0x80:
                n = ((n & 0x7f) << 8) | data[p]; p += 1
            n2 = data[p]; p += 1
            if n2 & 0x80:
                n2 = ((n2 & 0x7f) << 8) | data[p]; p += 1
            s = data[p:p + n2].decode("utf-8", "replace")
        else:
            n = struct.unpack("<H", data[p:p + 2])[0]; p += 2
            if n & 0x8000:
                n = ((n & 0x7fff) << 16) | struct.unpack("<H", data[p:p + 2])[0]; p += 2
            s = data[p:p + n * 2].decode("utf-16-le", "replace")
        out.append(s)
    return out

strings = parse_axml_strings(d)
print("axml strings:", len(strings) if strings else None)
if strings:
    for s in strings:
        print(repr(s))
