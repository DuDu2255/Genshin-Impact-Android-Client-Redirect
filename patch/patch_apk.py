#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
云编译改包主脚本 —— 从「官方原包」生成重定向改包（未签名）。

改动（相对官方原包，只动 3~5 个条目，其余逐字节保留）：
  1) assets/20527480.blk                     dispatch 域名 → 自建服务器
  2) assets/bin/Data/07134351...             Unity TextAsset：SDK 端点域名 → 自建服务器
  3) classes3.dex / classes4.dex             硬编码域名 → 自建服务器（baksmali/smali 重汇编）
  4) classes4.dex                            登录 RSA 公钥 → AstaPS 公钥（等长替换）
  5) assets/server_env_config.json           （可选）SDK 端点表

用法:
  python3 patch/patch_apk.py --in 原包.apk --out 改包.apk \
      [--host 127.0.0.1] [--port 10086] [--keyid 4] \
      [--java java] [--baksmali libs/baksmali.jar] [--smali libs/smali.jar] \
      [--workdir tmp] [--no-dex] [--no-key]
"""
import argparse, hashlib, os, re, shutil, struct, subprocess, sys, tempfile, zlib, zipfile

# ------------------------------------------------------------------ 常量
TEXTASSET = "assets/bin/Data/07134351e12778a4d9c727bb286b16c8"
BLK = "assets/20527480.blk"
SERVER_ENV = "assets/server_env_config.json"
DEXS = ["classes3.dex", "classes4.dex"]

# 登录加密公钥：旧（米哈游官方）→ 新（AstaPS auth_public-key，模数 00cb2b60fc…）
OLD_LOGIN_KEY = (
    b"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDvekdPMHN3AYhm/vktJT+YJr7cI5DcsNKqdsx5DZX0gDuWFuIjzdwButrIYPNmRJ1G8ybDIF7oDW2eEpm5sMbL9zs\n"
    b"9ExXCdvqrn51qELbqj0XxtMTIpaCHFSI50PfPpTFV9Xt/hmyVwokoOXFlAEgCn+Q\n"
    b"CgGs52bFoYMtyi+xEQIDAQAB\n"
)
NEW_LOGIN_KEY = (
    b"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDLK2D8f2XPsubRdwDwsyojJc9U0ClhNxJ6lPhUMsHiqqoULez8e6/y83vMD8/i6hEQi7wox6cAMWTu7CtlLGgxbAmC\n"
    b"foDuxsC3VyoBpRcH0ng3OEvTHcAVOIcRBvDzqFG+bZUaRsDmxaevQ1nDxIYEFj4Q\n"
    b"4PA0i3nUZ0EDt6hRBQIDAQAB\n"
)
assert len(OLD_LOGIN_KEY) == len(NEW_LOGIN_KEY) == 219

# 域名正则：https://<host>.(mihoyo|hoyoverse).com
DOMAIN_RE = re.compile(rb"https://[A-Za-z0-9._-]+\.(?:mihoyo|hoyoverse)\.com")
YUANSHEN_RE = re.compile(rb"https://[A-Za-z0-9._-]*yuanshen\.com")


def log(*a):
    print("[patch]", *a, flush=True)


# ------------------------------------------------------------------ 等长替换
def replace_urls(data, local, label):
    """把 https://*.mihoyo|hoyoverse.com 换成 local（等长：把多出的空格插在 URL 的引号前）。"""
    out = bytearray()
    pos = 0
    n = 0
    for m in DOMAIN_RE.finditer(data):
        s, e = m.start(), m.end()
        new = local.encode()
        if len(new) > (e - s):
            continue                      # 放不下，跳过
        pad = (e - s) - len(new)
        q = s - 1
        if q >= 0 and data[q:q + 1] == b'"':
            # 空格插在引号之前（JSON 合法空白），引号后跟新 URL
            out += data[pos:q]
            out += b" " * pad
            out += b'"'
            out += new
            pos = e
        else:
            # 没有引号：把空格补在 URL 之后（非 JSON 场景，尽量保守）
            out += data[pos:s]
            out += new + b" " * pad
            pos = e
        n += 1
    out += data[pos:]
    log(f"  {label}: 替换 {n} 处域名 → {local}")
    return bytes(out)


# ------------------------------------------------------------------ blk
def patch_blk(raw, local, keyid):
    import lz4.block
    HDR = 43
    assert raw[:4] == b"Blb\x03", "not a Blb file"
    content = bytearray(lz4.block.decompress(raw[HDR:], uncompressed_size=64 << 20))
    orig_len = len(content)
    text = bytes(content)
    text2 = YUANSHEN_RE.sub(local.encode(), text)
    if keyid is not None:
        text2 = re.sub(rb'("keyId"\s*:\s*)\d+', rb"\g<1>" + str(keyid).encode(), text2)
    diff = len(text) - len(text2)
    if diff > 0:                                   # 变短：在首个 { 后补空格
        j = text2.find(b"{")
        text2 = text2[:j + 1] + b" " * diff + text2[j + 1:]
    elif diff < 0:
        raise SystemExit("blk 新 URL 过长，无法等长")
    assert len(text2) == orig_len, "blk 长度不一致"
    payload = lz4.block.compress(bytes(text2), store_size=False)
    log(f"  blk: dispatch → {local}, keyId={keyid}, payload {orig_len}B")
    return raw[:HDR] + payload


# ------------------------------------------------------------------ dex
def patch_dex_domains(raw, workdir, java, baksmali, smali, local, label):
    d = os.path.join(workdir, label + ".dex")
    o = os.path.join(workdir, label + ".smali")
    with open(d, "wb") as f:
        f.write(raw)
    if os.path.isdir(o):
        shutil.rmtree(o)
    subprocess.run([java, "-jar", baksmali, "d", d, "-o", o], check=True)
    pat = re.compile(r"https://[A-Za-z0-9._-]*(?:mihoyo|hoyoverse)\.com")
    files = hits = 0
    for root, _, fs in os.walk(o):
        for fn in fs:
            if not fn.endswith(".smali"):
                continue
            p = os.path.join(root, fn)
            with open(p, "r", encoding="utf-8", errors="surrogateescape") as f:
                t = f.read()
            h = len(pat.findall(t))
            if h:
                files += 1
                hits += h
                with open(p, "w", encoding="utf-8", errors="surrogateescape") as f:
                    f.write(pat.sub(local, t))
    out = os.path.join(workdir, label + "_new.dex")
    subprocess.run([java, "-jar", smali, "a", o, "-o", out], check=True)
    log(f"  {label}: smali 域名替换 {files} 文件/{hits} 处 → 重汇编")
    return open(out, "rb").read()


def patch_login_key(raw, label):
    i = raw.find(OLD_LOGIN_KEY)
    if i < 0:
        log(f"  {label}: !! 未找到旧登录公钥，跳过")
        return raw
    d = bytearray(raw)
    d[i:i + 219] = NEW_LOGIN_KEY
    d[0x0C:0x20] = hashlib.sha1(bytes(d[0x20:])).digest()
    d[0x08:0x0C] = struct.pack("<I", zlib.adler32(bytes(d[0x0C:])) & 0xFFFFFFFF)
    log(f"  {label}: 登录公钥已替换（219B 等长）")
    return bytes(d)


# ------------------------------------------------------------------ zip 重打包
def repack(src_apk, out_apk, replacements):
    fin = open(src_apk, "rb")
    fin.seek(0, 2)
    size = fin.tell()
    back = min(size, 65557)
    fin.seek(size - back)
    buf = fin.read(back)
    idx = buf.rfind(b"PK\x05\x06")
    if idx < 0:
        raise RuntimeError("no EOCD")
    eocd_off = size - back + idx
    fin.seek(eocd_off)
    (sig, disk, cd_disk, n_this, n_total, cd_size, cd_off, com_len) = struct.unpack("<IHHHHIIH", fin.read(22))
    fin.seek(cd_off)
    cd = fin.read(cd_size)
    entries = []
    p = 0
    while p < len(cd):
        (sigc, vmade, vneed, flags, method, mtime, mdate, crc, comp, uncomp,
         fnl, exl, cml, dstart, iattr, eattr, loff) = struct.unpack("<IHHHHHHIIIHHHHHII", cd[p:p + 46])
        name = cd[p + 46:p + 46 + fnl]
        rec_len = 46 + fnl + exl + cml
        entries.append({"raw": cd[p:p + rec_len], "name": name, "flags": flags,
                        "comp": comp, "uncomp": uncomp, "loff": loff, "fnl": fnl, "exl": exl})
        p += rec_len

    fout = open(out_apk, "wb")
    new_offsets = []
    changed = 0
    for e in entries:
        name = e["name"].decode("utf-8", "replace")
        fin.seek(e["loff"])
        (lsig, lvneed, lflags, lmethod, ltime, ldate, lcrc, lcomp, luncomp, lfnl, lexl) = \
            struct.unpack("<IHHHHHIIIHH", fin.read(30))
        new_offsets.append(fout.tell())
        if name not in replacements:
            fin.seek(e["loff"])
            remain = 30 + lfnl + lexl + e["comp"]
            while remain > 0:
                chunk = fin.read(min(1 << 20, remain))
                if not chunk:
                    raise RuntimeError("eof " + name)
                fout.write(chunk)
                remain -= len(chunk)
        else:
            data = replacements[name]
            crc = zlib.crc32(data) & 0xFFFFFFFF
            co = zlib.compressobj(9, zlib.DEFLATED, -15)
            comp_data = co.compress(data) + co.flush()
            fin.seek(e["loff"] + 30 + lfnl)
            lextra = fin.read(lexl)
            flags = lflags & ~0x08
            fout.write(struct.pack("<IHHHHHIIIHH", 0x04034B50, lvneed, flags, 8, ltime, ldate,
                                   crc, len(comp_data), len(data), lfnl, lexl))
            fout.write(e["name"]); fout.write(lextra); fout.write(comp_data)
            e["_c"] = (crc, len(comp_data), len(data))
            changed += 1
            log(f"  替换条目 {name}  {e['uncomp']} → {len(data)}B")
    cd_new_off = fout.tell()
    for e, noff in zip(entries, new_offsets):
        rec = bytearray(e["raw"])
        struct.pack_into("<I", rec, 42, noff)
        if "_c" in e:
            crc, c, u = e["_c"]
            struct.pack_into("<I", rec, 16, crc)
            struct.pack_into("<I", rec, 20, c)
            struct.pack_into("<I", rec, 24, u)
            struct.pack_into("<H", rec, 8, e["flags"] & ~0x08)
        fout.write(rec)
    cd_new_size = fout.tell() - cd_new_off
    fin.seek(eocd_off + 22)
    comment = fin.read(com_len)
    ne = bytearray(struct.pack("<IHHHHIIH", sig, disk, cd_disk, n_this, n_total, cd_new_size, cd_new_off, com_len))
    fout.write(ne); fout.write(comment)
    fout.close(); fin.close()
    log(f"重打包完成：{changed} 条替换，输出 {out_apk} ({os.path.getsize(out_apk)}B)")


# ------------------------------------------------------------------ main
def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--in", dest="inp", required=True)
    ap.add_argument("--out", dest="out", required=True)
    ap.add_argument("--host", default="127.0.0.1")
    ap.add_argument("--port", type=int, default=10086)
    ap.add_argument("--keyid", type=int, default=4)
    ap.add_argument("--java", default="java")
    ap.add_argument("--baksmali", default="patch/libs/baksmali.jar")
    ap.add_argument("--smali", default="patch/libs/smali.jar")
    ap.add_argument("--workdir", default=None)
    ap.add_argument("--no-dex", action="store_true", help="跳过 dex 域名替换")
    ap.add_argument("--no-key", action="store_true", help="跳过登录公钥替换")
    args = ap.parse_args()

    local = f"http://{args.host}:{args.port}"
    workdir = args.workdir or tempfile.mkdtemp(prefix="yspatch_")
    os.makedirs(workdir, exist_ok=True)

    z = zipfile.ZipFile(args.inp)
    names = set(z.namelist())
    repl = {}

    log("== 1) blk ==")
    if BLK in names:
        repl[BLK] = patch_blk(z.read(BLK), local, args.keyid)
    else:
        log("  !! 未找到", BLK)

    log("== 2) TextAsset ==")
    if TEXTASSET in names:
        repl[TEXTASSET] = replace_urls(z.read(TEXTASSET), local, "TextAsset")

    log("== 3) server_env_config.json ==")
    if SERVER_ENV in names:
        repl[SERVER_ENV] = replace_urls(z.read(SERVER_ENV), local, "server_env")

    log("== 4) dex ==")
    for dn in DEXS:
        if dn not in names:
            log("  !! 未找到", dn)
            continue
        raw = z.read(dn)
        if not args.no_dex:
            raw = patch_dex_domains(raw, workdir, args.java, args.baksmali, args.smali, local, dn.replace(".", "_"))
        if dn == "classes4.dex" and not args.no_key:
            raw = patch_login_key(raw, dn)
        repl[dn] = raw

    log("== 5) 重打包 ==")
    repack(args.inp, args.out, repl)
    log("完成 →", args.out)


if __name__ == "__main__":
    main()
