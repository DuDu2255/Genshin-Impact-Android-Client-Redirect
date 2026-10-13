#!/usr/bin/env python3
"""把 smali 目录里所有 https://*.mihoyo.com / *.hoyoverse.com 的 host 换成 127.0.0.1:10086。
路径部分保留。用法: python3 smali_patch.py <smali_dir> [--dry]
"""
import os, re, sys

TARGET = "http://127.0.0.1:10086"
PAT = re.compile(r'https://[A-Za-z0-9._-]*(?:mihoyo|hoyoverse)\.com')

def main():
    d = sys.argv[1]
    dry = "--dry" in sys.argv
    total_files = 0
    total_hits = 0
    examples = []
    for root, _, files in os.walk(d):
        for fn in files:
            if not fn.endswith(".smali"):
                continue
            p = os.path.join(root, fn)
            with open(p, "r", encoding="utf-8", errors="surrogateescape") as f:
                txt = f.read()
            hits = PAT.findall(txt)
            if not hits:
                continue
            total_files += 1
            total_hits += len(hits)
            for h in hits[:2]:
                if len(examples) < 12:
                    examples.append((os.path.relpath(p, d), h))
            if not dry:
                new = PAT.sub(TARGET, txt)
                with open(p, "w", encoding="utf-8", errors="surrogateescape") as f:
                    f.write(new)
    print(f"files changed: {total_files}  host-replacements: {total_hits}")
    for e in examples:
        print("   ", e[1], "->", TARGET, "  in", e[0])

if __name__ == "__main__":
    main()
