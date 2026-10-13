import struct, hashlib, glob, os, re, base64

HEXCH = set(b'0123456789abcdefABCDEF')

def maximal_hex(d, pos):
    a = pos
    while a-1 >= 0 and d[a-1] in HEXCH:
        a -= 1
    b = pos
    while b < len(d) and d[b] in HEXCH:
        b += 1
    return d[a:b]

def parse_blob(hexbytes):
    raw = bytes.fromhex(hexbytes.decode())
    i = raw.find(bytes.fromhex('060200000024000052534131'))
    if i < 0:
        return None
    bitlen = struct.unpack_from('<I', raw, i+12)[0]
    pubexp = struct.unpack_from('<I', raw, i+16)[0]
    ml = bitlen//8
    mod = raw[i+20:i+20+ml]
    return (mod, pubexp, bitlen)

d = open(os.path.expanduser('~/apk_out/libyuanshen.so'), 'rb').read()
keys = []
for m in re.finditer(rb'52534131', d):
    k = parse_blob(maximal_hex(d, m.start()))
    if k:
        keys.append(k)

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
    return b'\x00\x01' + b'\xff'*(k-len(T)-3) + b'\x00' + T

content = open(os.path.expanduser('~/apk_out/qcr_content.bin'), 'rb').read()
sign = open(os.path.expanduser('~/apk_out/qcr_sign.bin'), 'rb').read()
qcr = open(os.path.expanduser('~/apk_out/qcr2.json'), 'rb').read()

msgs = {
 'content': content,
 'content_rev': content[::-1],
 'b64content': base64.b64encode(content),
 'sha256(content)': hashlib.sha256(content).digest(),
 'sha1(content)': hashlib.sha1(content).digest(),
 'md5(content)': hashlib.md5(content).digest(),
 'qcr_json': qcr,
}

for (mod, e, bl) in keys:
    if bl != 2048:
        continue
    for order in ('little', 'big'):
        n = int.from_bytes(mod, order)
        for sigorder in ('big', 'little'):
            s = int.from_bytes(sign, sigorder)
            if s >= n:
                continue
            em = pow(s, e, n).to_bytes(256, 'big')
            for h in OIDS:
                for mn, msg in msgs.items():
                    t = emsa(h, msg, 256)
                    if t and em == t:
                        print('HIT', order, sigorder, h, mn)
            if em[:2] == b'\x00\x01':
                i = em.find(b'\x00', 2)
                if i > 0:
                    print('PKCS1 raw tail:', em[i+1:].hex(), 'order', order, sigorder)
print('done')
