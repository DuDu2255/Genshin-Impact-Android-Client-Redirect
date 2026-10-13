import hashlib, os, base64, struct, re

def pem_to_der(p):
    ls = open(p).read().strip().splitlines()
    return base64.b64decode(''.join(l for l in ls if not l.startswith('-----')))

def read_tlv(d, i):
    t = d[i]; i += 1
    ln = d[i]; i += 1
    if ln & 0x80:
        m = ln & 0x7f; ln = int.from_bytes(d[i:i+m], 'big'); i += m
    return t, d[i:i+ln], i+ln

def parse_pub(path):
    der = pem_to_der(path)
    t, seq, _ = read_tlv(der, 0)
    i = 0; items = []
    while i < len(seq):
        t, v, i = read_tlv(seq, i); items.append(v)
    bits = items[1]
    if bits[0] == 0: bits = bits[1:]
    t2, rsaseq, _ = read_tlv(bits, 0)
    i = 0; vals = []
    while i < len(rsaseq):
        t, v, i = read_tlv(rsaseq, i); vals.append(int.from_bytes(v, 'big'))
    return vals[0], vals[1]

# .so 2048 key
def maximal_hex(d, pos):
    HEX = set(b'0123456789abcdefABCDEF')
    a = pos
    while a-1 >= 0 and d[a-1] in HEX: a -= 1
    b = pos
    while b < len(d) and d[b] in HEX: b += 1
    return d[a:b]

so = open(os.path.expanduser('~/apk_out/libyuanshen.so'), 'rb').read()
sokeys = []
for m in re.finditer(rb'52534131', so):
    raw = bytes.fromhex(maximal_hex(so, m.start()).decode())
    i = raw.find(bytes.fromhex('060200000024000052534131'))
    if i < 0: continue
    bl = struct.unpack_from('<I', raw, i+12)[0]
    if bl == 2048:
        sokeys.append(int.from_bytes(raw[i+20:i+20+256], 'little'))

cand = {}
cn, ce = parse_pub(os.path.expanduser('~/ys_keys/ServerPub.pem'))
cand['community_ServerPub'] = (cn, ce)
for j, n in enumerate(sokeys):
    cand[f'so2048_{j}'] = (n, 65537)

content = open(os.path.expanduser('~/apk_out/qcr_content.bin'), 'rb').read()
sign = open(os.path.expanduser('~/apk_out/qcr_sign.bin'), 'rb').read()
pt = open(os.path.expanduser('~/apk_out/qcr_plaintext.bin'), 'rb').read()

msgs = {
 'plaintext': pt,
 'plaintext_rev': pt[::-1],
 'b64_plaintext': base64.b64encode(pt),
 'content': content,
 'b64_content': base64.b64encode(content),
 'sha256_plaintext': hashlib.sha256(pt).digest(),
 'sha1_plaintext': hashlib.sha1(pt).digest(),
 'md5_plaintext': hashlib.md5(pt).digest(),
 'sha256_content': hashlib.sha256(content).digest(),
 'sha1_content': hashlib.sha1(content).digest(),
 'md5_content': hashlib.md5(content).digest(),
}

OIDS = {
 'md5': bytes.fromhex('3020300c06082a864886f70d020505000410'),
 'sha1': bytes.fromhex('3021300906052b0e03021a05000414'),
 'sha256': bytes.fromhex('3031300d060960864801650304020105000420'),
 'sha384': bytes.fromhex('3041300d060960864801650304020205000430'),
 'sha512': bytes.fromhex('3051300d060960864801650304020305000440'),
}

def emsa(h, msg, k):
    T = OIDS[h] + getattr(hashlib, h)(msg).digest()
    if len(T) > k-11: return None
    return b'\x00\x01' + b'\xff'*(k-len(T)-3) + b'\x00' + T

hit = False
for cname, (n, e) in cand.items():
    k = n.bit_length()//8
    if k != len(sign): continue
    s = int.from_bytes(sign, 'big')
    if s >= n: 
        print(cname, 'sign>=n'); continue
    em = pow(s, e, n).to_bytes(k, 'big')
    for h in OIDS:
        for mn, msg in msgs.items():
            t = emsa(h, msg, k)
            if t and em == t:
                print('HIT', cname, h, mn); hit = True
    if em[:2] == b'\x00\x01':
        i = em.find(b'\x00', 2)
        print('PKCS1 tail', cname, em[i+1:i+40].hex())
    else:
        print('no 0001 prefix', cname, 'em head', em[:4].hex())
print('HIT' if hit else 'none')
