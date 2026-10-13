#!/usr/bin/env python3
"""Minimal ProxyPin MCP client. Usage: python3 pp.py <tool> '<json-args>'"""
import sys, json, urllib.request

import os
URL = os.environ.get("PP_MCP_URL", "http://127.0.0.1:9127/mcp")
# ProxyPin MCP token —— 从环境变量读取，勿提交真实值
TOKEN = os.environ.get("PP_MCP_TOKEN", "PUT_YOUR_PROXYPIN_MCP_TOKEN_HERE")

def post(body):
    h = {"Authorization": f"Bearer {TOKEN}", "Content-Type": "application/json",
         "Accept": "application/json, text/event-stream"}
    req = urllib.request.Request(URL, data=json.dumps(body).encode(), headers=h, method="POST")
    with urllib.request.urlopen(req, timeout=60) as r:
        raw = r.read().decode("utf-8", "replace")
    if raw.lstrip().startswith("{"):
        return json.loads(raw)
    for line in raw.splitlines():
        if line.startswith("data:"):
            try:
                return json.loads(line[5:].strip())
            except Exception:
                pass
    return {"raw": raw}

def call(tool, args):
    post({"jsonrpc": "2.0", "id": 1, "method": "initialize",
          "params": {"protocolVersion": "2024-11-05", "capabilities": {},
                     "clientInfo": {"name": "pp", "version": "1"}}})
    try:
        post({"jsonrpc": "2.0", "method": "notifications/initialized"})
    except Exception:
        pass
    o = post({"jsonrpc": "2.0", "id": 2, "method": "tools/call",
              "params": {"name": tool, "arguments": args}})
    res = o.get("result", o)
    # MCP tool result: {content:[{type:text,text:...}], isError}
    if isinstance(res, dict) and "content" in res:
        out = []
        for c in res["content"]:
            out.append(c.get("text", ""))
        return "\n".join(out), res.get("isError", False)
    return json.dumps(res, ensure_ascii=False, indent=2), False

if __name__ == "__main__":
    tool = sys.argv[1]
    args = json.loads(sys.argv[2]) if len(sys.argv) > 2 else {}
    text, err = call(tool, args)
    if err:
        print("[TOOL ERROR]", file=sys.stderr)
    print(text)
