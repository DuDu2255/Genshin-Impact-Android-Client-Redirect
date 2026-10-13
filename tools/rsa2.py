import struct, hashlib, glob, os, re

HEXCH = set(b'0123456789abcdefABCDEF')

def maximal_hex(d, pos):
    # pos inside a hex run; expand both directions
    a = pos
    while a-1 >= 0 and d[a-1] in HEXCH:
        a -= 1
    b = pos
    while b < len(d) and d[b] in HEXCH:
        b += 1
    return d[a:b]

def parse_blob(hexbytes):
    raw = bytes.fromhex(hexbytes.decode())
    i = raw.find(b'\x06\x02\x00\x00\x00\x24\x00\x00\x52\x53\x41\x31')
    if i < 0:
        i = raw.find(b'\x06\x02\x00\x00\x00\xa4\x00\x00\x52\x53\x41\x31')
    if i < 0:
        return None
    bitlen = struct.unpack_from('<I', raw, i+12)[0]
    pubexp = struct.unpack_from('<I', raw, i+16)[0]
    if bitlen % 8 or not (512 <= bitlen <= 4096):
        return None
    ml = bitlen//8
    mod = raw[i+20:i+20+ml]
    if len(mod) < ml:
        return None
    return (int.from_bytes(mod, 'little'), pubexp, bitlen)

libs = glob.glob(os.path.expanduser('~/apk_out/lib/*.so')) + [os.path.expanduser('~/apk_out/libyuanshen.so')]
keys = {}
for L in libs:
    d = open(L, 'rb').read()
    for m in re.finditer(rb'52534131', d):
        hb = maximal_hex(d, m.start())
        k = parse_blob(hb)
        if k:
            keys[k] = os.path.basename(L)
print('unique parsed keys:', len(keys))
for (n, e, bl), src in sorted(keys.items(), key=lambda x: x[0][2]):
    print(f'  bitlen={bl} e={e} src={src} n[:20]={n.to_bytes(bl//8, "big")[:20].hex()}')

OIDS = {
 'md5': bytes.fromhex('3020300c06082a864886f70d020505000410'),
 'sha1': bytes.fromhex('3021300906052b0e03021a05000414'),
 'sha256': bytes.fromhex('3031300d060960864801650304020105000420'),
 'sha384': bytes.fromhex('3041300d060960864801650304020205000430'),
 'sha512': bytes.fromhex('3051300d060960864801650304020305000440'),
}

def emsa(h, msg, k):
    T = OIDS[h] + getattr(hashlib, h)(msg).digest()
    if len(T) > k-11:
        return None
    return b'\x00\x01'+b'\xff'*(k-len(T)-3)+b'\x00'+T

def verify(n, e, sig, msg, k):
    s = int.from_bytes(sig, 'big')
    if s >= n:
        return None
    em = pow(s, e, n).to_bytes(k, 'big')
    for h in OIDS:
        t = emsa(h, msg, k)
        if t and em == t:
            return h
    return None

content = open(os.path.expanduser('~/apk_out/qcr_content.bin'), 'rb').read()
sign = open(os.path.expanduser('~/apk_out/qcr_sign.bin'), 'rb').read()
print('content', len(content), 'sign', len(sign))

hit = False
for (n, e, bl) in keys:
    if bl//8 != len(sign):
        continue
    for mn, msg in [('content', content), ('content_rev', content[::-1]),
                    ('sha256(content)', hashlib.sha256(content).digest()),
                    ('sign_swapped', None)]:
        if msg is None:
            continue
        r = verify(n, e, sign, msg, bl//8)
        if r:
            print('VERIFY OK', bl, mn, r)
            hit = True
print('HIT' if hit else 'none verified')
