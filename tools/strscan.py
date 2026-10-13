import struct, os

d = open(os.path.expanduser('~/apk_out/global-metadata.dat'), 'rb').read()
M = (1 << 64) - 1
A = 0x75B679DAF67C3F24
B = 0x907C49622D94D21A
C = 0x3E693CD23A41FDEF

def printable(b):
    return all((32 <= x < 127) or x == 0 for x in b)

# Scan every offset as candidate blob start (string_offset=0 -> seed=A).
n = len(d)
cands = []
# process in chunks for speed
CH = 1 << 20
for base in range(0, n, CH):
    chunk = d[base:base+CH+16]
    for i in range(0, min(CH, n-base)):
        q = chunk[i:i+8]
        if len(q) < 8:
            break
        v = int.from_bytes(q, 'little') ^ A
        # quick reject: check a couple bytes
        if (v & 0xff) in (0, ) or not (32 <= (v & 0xff) < 127):
            # still allow first byte 0 only rarely; require printable first byte
            if not ((32 <= (v & 0xff) < 127)):
                continue
        pb = v.to_bytes(8, 'little')
        if printable(pb):
            cands.append(base + i)
    if len(cands) > 4000:
        break

print("candidates (first-qword printable with seed=A):", len(cands))
# verify each candidate over several qwords
best = []
for off in cands[:4000]:
    seed = A
    p = off
    out = b''
    ok = 0
    for k in range(8):
        if p+8 > n:
            break
        q = int.from_bytes(d[p:p+8], 'little')
        v = (q ^ seed).to_bytes(8, 'little')
        if not printable(v):
            break
        out += v
        ok += 1
        seed = (seed + C) & M
        p += 8
    if ok >= 4:
        best.append((ok, off, out))
best.sort(reverse=True)
print("verified candidates:", len(best))
for ok, off, out in best[:20]:
    print(f"off={off:#x} qwords={ok} text={out[:64]!r}")
