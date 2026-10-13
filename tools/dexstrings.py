import struct, sys

def read_uleb(d,p):
    r=0; s=0
    while True:
        b=d[p]; p+=1
        r |= (b & 0x7f) << s
        if not (b & 0x80): break
        s+=7
    return r,p

def parse(path):
    d=open(path,'rb').read()
    assert d[:8]==b'dex\n035\x00', d[:8]
    string_ids_size, string_ids_off = struct.unpack_from('<II', d, 0x38)
    strs=[]; offs=[]
    for i in range(string_ids_size):
        off, = struct.unpack_from('<I', d, string_ids_off+4*i)
        offs.append(off)
        p=off
        n,p = read_uleb(d,p)
        strs.append(d[p:p+n])
    return d, offs, strs

if __name__=='__main__':
    path=sys.argv[1]
    d,offs,strs=parse(path)
    print("count", len(strs))
    bad=0
    for i in range(1,len(strs)):
        if strs[i-1] > strs[i]:
            bad+=1
            if bad<=8:
                print("ORDER-BAD", i-1, strs[i-1][:70], "||", strs[i][:70])
    print("out-of-order pairs:", bad)
    for i,s in enumerate(strs):
        if b'mihoyo.com' in s or b'hoyoverse.com' in s or b'127.0.0.1' in s:
            print(f"[{i:6d}] {s.decode('utf-8','replace')}")
