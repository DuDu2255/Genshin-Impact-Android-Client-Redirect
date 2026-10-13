#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
原神 assets/*.blk 解包 / 重打包工具 (20527480.blk 等"配置型" blk)

已确认格式 (2026-10-13):
  偏移 0   : 4 字节 magic  "Blb\\x03"  (42 6c 62 03)
  偏移 4   : u32 = 0x75 = 117   (全部样本恒定)
  偏移 8   : u32 = 5            (全部样本恒定)
  偏移 12  : 31 字节            (每文件不同; 用途未知, 疑似校验/随机; 原样保留!)
  偏移 43  : LZ4 block 载荷     (标准 lz4 block, 无帧头)
            - 可能带 64KB 预置字典 (游戏端有 "missing LZ dictionary")
            - 原版 20527480.blk 未用字典 -> 我们可纯 LZ4 重压, 游戏能读

用法:
  python3 blk_tool.py dump   <in.blk> [out.bin]     # 解包
  python3 blk_tool.py pack   <in.blk> <content.bin> <out.blk>   # 用原头部+新内容重打包
  python3 blk_tool.py replace <in.blk> <old> <new> <out.blk>    # 文本替换后重打包
"""
import sys, lz4.block

HDR = 43  # magic(4)+u32(4)+u32(4)+31


def load(path):
    return open(path, 'rb').read()


def dump(inp, outp=None):
    b = load(inp)
    assert b[:4] == b'Blb\x03', "not a Blb file"
    content = lz4.block.decompress(b[HDR:], uncompressed_size=64 << 20)
    if outp:
        open(outp, 'wb').write(content)
    return content


def pack(inp, content, outp):
    """用 in.blk 的 43 字节原头部 + 新 content 重打包(纯 LZ4, 无字典)。"""
    b = load(inp)
    assert b[:4] == b'Blb\x03'
    header = b[:HDR]                      # 原样保留头部(含那 31 字节)
    payload = lz4.block.compress(content, store_size=False)
    open(outp, 'wb').write(header + payload)
    return len(header) + len(payload)


def replace(inp, old, new, outp):
    content = bytearray(dump(inp))
    old, new = old.encode(), new.encode()
    n = content.count(old)
    if n == 0:
        print("!! 未找到待替换文本:", old)
        return None
    diff = len(old) - len(new)
    content = bytes(content).replace(old, new)
    if diff != 0:
        # 保持总长度不变: 在 JSON 首个 '{' 之后插入/删除空格(字符串外的空白, 不影响语义)
        j = content.find(b'{')
        if diff > 0:
            content = content[:j + 1] + b' ' * diff + content[j + 1:]
        else:
            k = j + 1
            removed = 0
            while removed < -diff and k < len(content) and content[k:k + 1] == b' ':
                k += 1; removed += 1
            content = content[:j + 1] + content[k:]
    size = pack(inp, content, outp)
    print(f"替换 {n} 处, 输出 {outp} ({size} 字节)")
    return size


if __name__ == '__main__':
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(1)
    cmd = sys.argv[1]
    if cmd == 'dump':
        c = dump(sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else None)
        print(f"解包 {len(c)} 字节")
    elif cmd == 'pack':
        print("写出", pack(sys.argv[2], load(sys.argv[3]), sys.argv[4]), "字节")
    elif cmd == 'replace':
        replace(sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5])
    else:
        print(__doc__)
