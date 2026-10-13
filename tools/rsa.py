import struct, hashlib, glob, os, re

def parse_capi(data, off):
    if data[off:off+4] != b'RSA1':
        return None
    bitlen = struct.unpack_from('<I', data, off+4)[0]
    pubexp = struct.unpack_from('<I', data, off+8)[0]
    if bitlen % 8 or bitlen < 512 or bitlen > 4096:
        return None
    modlen = bitlen//8
    mod = data[off+12:off+12+modlen]
    if len(mod) < modlen:
        return None
    n = int.from_bytes(mod, 'little')
    return (n, pubexp, bitlen)

def collect(path):
    d = open(path, 'rb').read()
    keys = []
    for m in re.finditer(rb'RSA1', d):
        k = parse_capi(d, m.start())
        if k:
            keys.append(k)
    return keys

OIDS = {
 'md5': bytes.fromhex('3020300c06082a864886f70d020505000410'),
 'sha1': bytes.fromhex('3021300906052b0e03021a05000414'),
 'sha256': bytes.fromhex('3031300d060960864801650304020105000420'),
 'sha384': bytes.fromhex('3041300d060960864801650304020205000430'),
 'sha512': bytes.fromhex('3051300d060960864801650304020305000440'),
}

def emsa(hname, msg, k):
    h = getattr(hashlib, hname)(msg).digest()
    T = OIDS[hname] + h
    if len(T) > k-11:
        return None
    return b'\x00\x01' + b'\xff'*(k-len(T)-3) + b'\x00' + T

def verify(n, e, sig, msg, k):
    s = int.from_bytes(sig, 'big')
    if s >= n:
        return None
    m = pow(s, e, n)
    em = m.to_bytes(k, 'big')
    for h in ['sha256', 'sha1', 'md5', 'sha512', 'sha384']:
        t = emsa(h, msg, k)
        if t and em == t:
            return h
    if em[:2] == b'\x00\x01':
        i = em.find(b'\x00', 2)
        if i > 0 and em[i+1:] == msg:
            return 'raw'
    return None

libs = glob.glob(os.path.expanduser('~/apk_out/lib/*.so')) + [os.path.expanduser('~/apk_out/libyuanshen.so')]
allkeys = {}
for L in libs:
    ks = collect(L)
    if ks:
        print(os.path.basename(L), len(ks), 'capi keys; bitlens', sorted(set(k[2] for k in ks)))
    for k in ks:
        allkeys[k] = k
print('unique keys:', len(allkeys))
for (n, e, bl) in allkeys:
    print(f'  bitlen={bl} e={e} n[:16]={n.to_bytes(bl//8, "big")[:16].hex()}')

content = open(os.path.expanduser('~/apk_out/qcr_content.bin'), 'rb').read()
sign = open(os.path.expanduser('~/apk_out/qcr_sign.bin'), 'rb').read()
print('content', len(content), 'sign', len(sign))

found = False
for (n, e, bl) in allkeys:
    if bl//8 != len(sign):
        continue
    for msgname, msg in [('content', content), ('content_rev', content[::-1]),
                         ('sha256(content)', hashlib.sha256(content).digest())]:
        r = verify(n, e, sign, msg, bl//8)
        if r:
            print('VERIFY OK', bl, msgname, r)
            found = True
print('found' if found else 'none verified')
