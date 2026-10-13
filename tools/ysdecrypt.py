import base64, hashlib, os

def pem_to_der(path):
    lines = open(path).read().strip().splitlines()
    b = ''.join(l for l in lines if not l.startswith('-----'))
    return base64.b64decode(b)

def read_tlv(d, i):
    tag = d[i]; i += 1
    ln = d[i]; i += 1
    if ln & 0x80:
        n = ln & 0x7f
        ln = int.from_bytes(d[i:i+n], 'big'); i += n
    return tag, d[i:i+ln], i+ln

def parse_ints(der):
    # der is SEQUENCE content
    i = 0
    out = []
    while i < len(der):
        t, v, i = read_tlv(der, i)
        out.append((t, v))
    return out

def parse_priv(path):
    der = pem_to_der(path)
    t, seq, _ = read_tlv(der, 0)  # SEQUENCE
    items = parse_ints(seq)
    vals = [int.from_bytes(v, 'big') for _, v in items]
    # version, n, e, d, p, q, dp, dq, qinv
    return vals[1], vals[2], vals[3], vals[4], vals[5]  # n,e,d,p,q

def parse_pub(path):
    der = pem_to_der(path)
    t, seq, _ = read_tlv(der, 0)
    items = parse_ints(seq)
    # [0]=AlgorithmIdentifier SEQUENCE, [1]=BIT STRING
    bits = items[1][1]
    if bits[0] == 0:
        bits = bits[1:]
    t2, rsaseq, _ = read_tlv(bits, 0)
    vals = [int.from_bytes(v, 'big') for _, v in parse_ints(rsaseq)]
    return vals[0], vals[1]  # n,e

def pkcs1_unpad(m, k):
    # m is k bytes
    if m[0] != 0 or m[1] != 2:
        return None
    i = m.find(b'\x00', 2)
    if i < 0:
        return None
    return m[i+1:]

def rsa_decrypt_chunks(ct, n, d, k):
    out = b''
    for i in range(0, len(ct), k):
        c = int.from_bytes(ct[i:i+k], 'big')
        m = pow(c, d, n).to_bytes(k, 'big')
        p = pkcs1_unpad(m, k)
        if p is None:
            return None
        out += p
    return out

def rsa_verify_sha256(n, e, sig, msg, k):
    s = int.from_bytes(sig, 'big')
    if s >= n:
        return False
    em = pow(s, e, n).to_bytes(k, 'big')
    T = bytes.fromhex('3031300d060960864801650304020105000420') + hashlib.sha256(msg).digest()
    want = b'\x00\x01' + b'\xff'*(k-len(T)-3) + b'\x00' + T
    return em == want

content = open(os.path.expanduser('~/apk_out/qcr_content.bin'), 'rb').read()
sign = open(os.path.expanduser('~/apk_out/qcr_sign.bin'), 'rb').read()

sn, se = parse_pub(os.path.expanduser('~/ys_keys/ServerPub.pem'))
print('ServerPub n bits', sn.bit_length(), 'e', se)

for kid in [2, 3, 4]:
    try:
        n, e, d, p, q = parse_priv(os.path.expanduser(f'~/ys_keys/ClientPri{kid}.pem'))
    except Exception as ex:
        print(kid, 'parse fail', ex); continue
    k = n.bit_length()//8
    print(f'ClientPri{kid}: {n.bit_length()} bits, modulus head {n.to_bytes(k,"big")[:8].hex()}')
    if k == 256 and len(content) % 256 == 0:
        pt = rsa_decrypt_chunks(content, n, d, 256)
        if pt is not None:
            print(f'  >>> DECRYPT OK with ClientPri{kid}! plaintext len {len(pt)}')
            print('  head:', pt[:80].hex())
            open(os.path.expanduser('~/apk_out/qcr_plaintext.bin'), 'wb').write(pt)
            # verify sign over plaintext
            if rsa_verify_sha256(sn, se, sign, pt, sn.bit_length()//8):
                print('  >>> SIGN VERIFIED against ServerPub over plaintext!')
            else:
                print('  sign NOT verified against ServerPub (over plaintext)')
        else:
            print(f'  decrypt failed with ClientPri{kid}')
