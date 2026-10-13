# redirect-proxy · 原神 7.1.0 安卓客户端 私服重定向 & 改包

> 把原神（CN 安卓版）官方客户端的 **登录 / dispatch（区服调度）** 流量导向自建服务端
> （示例：[AstaPS](https://github.com/MeChen618/AstaPS)，Grasscutter 的 7.1.0 分支）。
>
> 本仓库 = 完整文档 + 逆向/改包工具脚本 + blk 样本，用于**在 GitHub 上维护这套改包方案**。

> ⚠️ 免责声明：仅供个人设备逆向学习与私服研究。官方 APK / 游戏资源版权归米哈游所有，
> 本仓库**不含**官方 APK 本体。使用者需自行持有合法客户端，自负一切后果。

---

## 目录
1. [总览：两条路线](#1-总览两条路线)
2. [客户端网络流程（实测）](#2-客户端网络流程实测)
3. [服务端：AstaPS](#3-服务端astaps)
4. [Dispatch 协议](#4-dispatch-协议)
5. [可改点定位](#5-可改点定位)
6. [blk 容器格式](#6-blk-容器格式)
7. [改包流程](#7-改包流程)
8. [云编译（GitHub Actions）](#8-云编译github-actions)
9. [代理路线（ProxyPin）](#9-代理路线proxypin)
10. [关键问题与结论](#10-关键问题与结论)
11. [参考包分析（惊蛰 6.7）](#11-参考包分析惊蛰-67)
12. [工具脚本](#12-工具脚本)
13. [仓库文件清单](#13-仓库文件清单)
14. [已知问题 / TODO](#14-已知问题--todo)

---

## 1. 总览：两条路线

| 路线 | 做法 | 优点 | 缺点 |
|---|---|---|---|
| **A. 代理** | 客户端**不动**，用 ProxyPin 在网络层把域名重写到 `127.0.0.1` | 简单；**已实测能进游戏**（保留真实域名，过域名校验） | 需常开代理 + 装证书 |
| **B. 改包** | 改 APK 里的 dispatch / 登录端点 / 登录公钥，重签名安装 | 不依赖代理 | 触发 **4214 域名指向校验**；本轮出现 **闪退**（§10.3） |

> 结论：**A 路线已能进游戏**；B 路线登录已打通，卡在「4214 域名校验」与「闪退」。

---

## 2. 客户端网络流程（实测）

用 ProxyPin 抓官方客户端，请求顺序：

```
1) passport-api.mihoyo.com        /account/ma-cn-passport/app/verify       (SDK 校验)
2) passport-api.mihoyo.com        /account/ma-cn-passport/app/exchange
3) hk4e-sdk.mihoyo.com            /hk4e_cn/combo/granter/login/v2/login    (combo 登录)
4) dispatchcnglobal.yuanshen.com  /query_region_list                       (区服列表, GET)
5) cngfdispatch.yuanshen.com      /query_cur_region                        (当前区服)
6) <游戏网关>                       KCP/UDP :22101                           (进场景)
```

### 两条登录通道（AstaPS 侧）

| 通道 | 路由 | 认证器 | 说明 |
|---|---|---|---|
| shield | `/hk4e_cn/mdk/shield/api/login` | `PasswordAuthenticator` | 按**明文账号名**查库；**密码解不开也放行** |
| ma-passport | `/account/ma-cn-passport/app/loginByPassword` | `MaPassportAuthenticator` | account 是 **RSA 密文**，解不开即失败 |

> **干净客户端（无存档官服账号）走 shield，能进；**
> 保存过官服账号后重启会走 ma-passport/token → 失败。
> ⇒ 测试前**先卸载/清账号**。

---

## 3. 服务端：AstaPS

- 项目：`https://github.com/MeChen618/AstaPS`（Grasscutter 7.1.0 分支）
- 依赖：**JDK 21** + **MongoDB 7** + 7.1 资源包（`Resource.zip`）
- 示例部署：proot Ubuntu Noble 容器 `…/ubuntu-noble_arm64/root/AstaPS`

`config.json` 关键项：

```jsonc
{
  "http": { "bindAddress": "0.0.0.0", "bindPort": 10086,
            "accessAddress": "127.0.0.1", "accessPort": 10086 },
  "game": { "bindAddress": "0.0.0.0", "bindPort": 22101 }
}
```

启动（proot 容器内）：

```bash
CT=$HOME/.local/share/tmoe-linux/containers/proot/ubuntu-noble_arm64/usr/local/etc/tmoe-linux/container/tmoe-linux-container
printf 'cd /root/AstaPS && exec ./start-server.sh\n' | bash "$CT"
# 约 15s 后：curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:10086/  → 200
```

- `10086` = HTTP(Dispatch)，`22101` = **KCP/UDP**（TCP refused 正常）。
- 后台进程随会话结束被回收，**每次用前需重启**。

内置密钥：
`keys/auth_public-key.pem`（模数 `00cb2b60fc…`）、`keys/auth_private-key.der`（同对）、
`keys/SigningKey.pem`（**区服签名私钥**）、`keys/game_keys/{2,3,4,5}_Pub.der`。

---

## 4. Dispatch 协议

来源：社区教程 + Grasscutter `Crypto.java`。

- **`query_region_list`**（GET，参数 `version/lang/platform/binary/time/channel_id/sub_channel_id`）
  → base64 protobuf：区服列表 + `client_secret_key`(Ec2b…) + `client_custom_config`（与 DISPATCH_KEY 异或）。
- **`query_cur_region`**（GET，参数 `… + account_type + dispatchSeed + key_id`）
  → JSON `{content, sign}`：
  - `content` = **客户端公钥 ClientPub 加密**（PKCS#1 v1.5，**245 字节/块**），客户端用 ClientPri 解。
  - `sign` = **SHA256withRSA**，签**明文 regionInfo**，客户端用 **ServerPub** 验签。

私服要点：① 用 ClientPub 加密 content；② 用自己密钥替换客户端里的 **ServerPub**（或跳过验签）。

**密钥现状（7.1.0）**：
- `keyId=4` 的 ClientPri 自 2024 未轮换（社区已知），可解密 `qcr_content.bin`。
- **ServerPub 已轮换且不在明文**（`libyuanshen.so` 里 7 个公钥均不是）。
- AstaPS 用**社区已知密钥对**（模数 `c5b6f1da6d5f787c…`，见 `SigningKey.pem` / `game_keys/4_Pub.der` /
  PC 补丁 `capyb2222/animegamepatch`）⇒ **ServerPri = AstaPS `SigningKey.pem`**。

---

## 5. 可改点定位

| 目标 | 文件 | 说明 |
|---|---|---|
| dispatch 地址 | `assets/20527480.blk` | Blb 容器 + LZ4，内含 `DispatchConfig` JSON |
| SDK 端点表 | `assets/bin/Data/07134351e12778a4d9c727bb286b16c8` | **Unity TextAsset**（475KB），客户端**真正读取**；改 `server_env_config.json` 不生效 |
| SDK 端点表（备用） | `assets/server_env_config.json` | 明文 JSON 数组（8 套 env） |
| 登录域名 | `classes3.dex` / `classes4.dex` | `PorteInfo` / `SDKHost` / combo/MDK 域名 |
| 登录加密公钥 | `classes4.dex` → `…/account/sdk/utils/RSAUtils` | 写死的 `RSA_PUBLIC_KEY` |

---

## 6. blk 容器格式

```
0x00  4B    magic "Blb\x03" = 42 6c 62 03
0x04  u32   = 0x75 (117)   —— 全样本恒定
0x08  u32   = 5            —— 全样本恒定
0x0C  31B   每文件不同，用途未知（疑似校验/nonce；**重打包原样保留**）
0x2B(=43)   LZ4 block 载荷（标准 lz4 block，无帧头）
```

- 解包：`lz4.block.decompress(b[43:], uncompressed_size=N)`。
- **可选带 64KB 预置字典**（`LZ4_decompress_safe_withPrefix64k`）；但**原版 20527480.blk 无字典**，
  重打包可不用字典，游戏照读。社区 `expert.blk` 用了字典。
- 解出内容（5501B）= `[ASB 前缀]` + `"channelconfig.asb"`(4177) + JSON(4329..5501)；
  JSON 前填充 `0xE9E9`（**非长度字段**）。

DispatchConfig JSON 关键字段：

```jsonc
{ "ChannelName": "CNRELAndroid",
  "DispatchConfigs": [ { "DispatchName": "cn",
      "DispatchUrls": [ "https://dispatchcnglobal.yuanshen.com/query_region_list" ] } ],
  "RSAParam": { "keyId": 4 } }
```

**31 字节字段排查结论**：非 md5/sha1/sha256/sha3/blake2b/xxhash 变体、非常量 XOR、非子串、非前缀哈希；
8 个样本全不匹配 ⇒ 疑似随机 nonce/自定义校验，**保留原值最安全**。

工具 `tools/blk_tool.py`：

```bash
python3 tools/blk_tool.py dump    <in.blk> [out.bin]
python3 tools/blk_tool.py pack    <in.blk> <content.bin> <out.blk>
python3 tools/blk_tool.py replace <in.blk> <old> <new> <out.blk>   # 文本替换 + 等长补齐
```

---

## 7. 改包流程

相对自己的 clone 包，只替换 3~4 个条目（其余逐字节保留）：

| 文件 | 改什么 |
|---|---|
| `assets/20527480.blk` | dispatch URL → 自建服务器 |
| `assets/bin/Data/07134351…` | 3634 处 `https://*.mihoyo.com` → `http://127.0.0.1:10086` |
| `classes3.dex` | 硬编码域名 → `http://127.0.0.1:10086` |
| `classes4.dex` | 域名替换 + **登录公钥替换**（§10.1） |

重打包脚本 `tools/repack*.py`（zip 级替换，**保留未改条目原始字节与 `.so` 对齐**）：

```bash
python3 tools/repack4.py     # 按脚本顶部 SRC/OUT/REPL 常量改路径后运行
```

**签名（必须）**：用 MT 管理器对未签名 APK **直接签名**（自动 v1+v2+v3）；
**不要**用「解压再压缩」方式改包（会破坏 `.so` 对齐，Android 11+ 装不上）。
本包 `extractNativeLibs=true`（`.so` 压缩存储），**无需 zipalign**。

**dex 字符串排序坑**：DEX 要求 `string_ids` 按 UTF-16 排序，ART 会校验。
直接就地改 `https://`→`http://` 会触发 *Out-of-order string_ids* → **闪退**。
所以域名替换用 `tools/dex_patch2.py`（**等长**替换，`http://000…@127.0.0.1:10086<path>`，
userinfo 被忽略、host 仍是 127.0.0.1），或走 baksmali/smali 重汇编。

---

## 8. 云编译（GitHub Actions）—— 从官方原包一键改包

仓库自带工作流 `.github/workflows/build.yml`：**从官方原包自动改包 + 签名**，产物发到 Release。

### 一次性准备
1. 把**未改动的官方原包**上传成 Release 资源（tag = `base`）：
   ```bash
   gh release create base ./原神官方原包.apk
   ```
   （或 GitHub 网页 → Releases → Draft a new release，tag 填 `base`，附上 APK）
2. `patch/`、`keystore/yspatch.keystore` 已在仓库中。

### 触发
Actions → `build-patched-apk` → **Run workflow**，可填 `host` / `port` / `keyid` / `base_tag`。
产物：`build-<n>` Release 里的**已签名改包 APK**（以及 Actions Artifact）。

### 签名
内置 keystore：`keystore/yspatch.keystore`，alias `yspatch`，store/key 口令均 `yspatch123`。
（仅用于改包 APK 自签名，非机密；换 key 就重新生成同名文件覆盖。）

### 管线做的事（`patch/patch_apk.py`）
1. `assets/20527480.blk` → dispatch 域名换成 `http://<host>:<port>`（等长）
2. `assets/bin/Data/07134351…`（TextAsset）→ 所有 `https://*.mihoyo|hoyoverse.com` → `http://<host>:<port>`（等长）
3. `classes3.dex` / `classes4.dex` → **baksmali 反编译 → 域名替换 → smali 重汇编**（规避 string_ids 排序坑）
4. `classes4.dex` → 登录 RSA 公钥**等长替换**为 AstaPS 公钥（修 ma-passport）
5. `assets/server_env_config.json` → 端点域名替换（可选）
6. zip 级重打包（未改条目逐字节保留、`.so` 对齐不变）→ 签名

本地等价运行：
```bash
python3 patch/patch_apk.py --in 官方原包.apk --out 改包_unsigned.apk \
    --host 127.0.0.1 --port 10086 --keyid 4 \
    --java java --baksmali patch/libs/baksmali.jar --smali patch/libs/smali.jar
```

> 依赖：Python3 + `lz4`；Java（baksmali/smali）。签名用 `uber-apk-signer`（CI 自动下载）。

---

## 9. 代理路线（ProxyPin）

- 客户端**保持原样**（真域名 → 过域名校验）。
- ProxyPin 4 条重定向规则（`http://127.0.0.1:10086/*`）：
  `dispatchcnglobal.yuanshen.com/*`、`cngfdispatch.yuanshen.com/*`、
  `hk4e-sdk.mihoyo.com/*`、`passport-api.mihoyo.com/*`。
- 重写机制：`*` 通配，规则 URL 去 `*` 作前缀、剩余部分填入重定向 URL 的 `*`；**每个域名单独一条**。
- `tools/pp.py` 为 ProxyPin MCP 客户端（token 走环境变量 `PP_MCP_TOKEN`）。

---

## 10. 关键问题与结论

### 10.1 登录公钥（ma-passport 解不开）—— ✅ 已解决

- 客户端在发送账号/密码前，用 **dex 里写死的 RSA 公钥**加密：
  `classes4.dex` → `com/mihoyo/platform/account/sdk/utils/RSAUtils.RSA_PUBLIC_KEY`
  （`MIGfMA0…`，216 base64 + 3 换行 = 219 字节），`encryptByPublicKey()` 被 `LoginManager` 调用。
- AstaPS 的 `auth_public-key.pem` 也是 **216 base64**（同一对，模数 `00cb2b60fc…`）
  ⇒ **可等长原地替换**（只重算 dex 头部 checksum/SHA1，`string_ids` 排序仍通过）。
- **实测成功**：替换后 ma-passport 登录通过，日志出现
  `User 1 has successfully logged in` → `[Combo] credential verification=true`。

### 10.2 4214「域名指向校验」—— 🔴 改包路线根因

- 客户端卡在「准备下载资源」，弹「网络错误 / 错误码:**4214**」。
- GenKit FAQ / 社区：**新版本对「域名指向」有校验**，请求 URL 指向 **IP**（非域名）即报 4214；
  官方解法是客户端二进制补丁（`genshin-patch.zip`，**链接已 404**，本仓库无）。
- 证据链：改包把 dispatch 指向 `http://127.0.0.1:10086`（**IP**）→ 触发校验；
  **代理路线能进游戏**正因它**没动 blk**，客户端仍用真域名。
- 校验**不在** dex / native 白名单 / 配置文件里；应在 **C#（`libyuanshen.so` IL2CPP）**，
  其字符串在**加密的 `global-metadata.dat`（MHY0）**内，明文搜不到。

### 10.3 redirect4 闪退 —— ⏳ 当前卡点

| | 原版 | redirect3 | redirect4 |
|---|---|---|---|
| dispatch | `https://dispatchcnglobal.yuanshen.com/query_region_list` | `http://127.0.0.1:10086/...`（IP） | `http://yuanshen.com.127.0.0.1.nip.io:10086/...`（域名，解析到 127.0.0.1） |
| 结果 | 正常 | 能跑，卡 4214 | **启动闪退** |

- redirect4 思路：用 **nip.io 通配 DNS**，让 host **是域名**（含 `yuanshen.com`）又解析到 `127.0.0.1`，
  以过「域名校验」。
- 核对：redirect4 的 blk 与源文件 md5 一致、JSON 合法、总长 5501 与原版等长、43B 头（含 31B）原样；
  **与 redirect3 只差 blk**。
- 但装机后**闪退**。⇒ 闪退与 blk 结构无关，疑似客户端对 nip.io 域名/域名校验的处理，或 DNS 解析失败。
- 待验证方向：① 关掉 fake-IP 代理重测（代理会把域名解析成 `198.18.x.x`）；
  ② 换等长域名（`*.sslip.io`）；③ 若仍崩，说明校验更严（要求米忽悠域名/公网 IP），
  改包路线需**绕过校验**（参考包那种 hook）。

---

## 11. 参考包分析（惊蛰 6.7）

> 📄 完整流程见 **[`docs/04_参考包_惊蛰6.7_流程.md`](docs/04_参考包_惊蛰6.7_流程.md)**
> （含 `libreadtoendhook.so` 反汇编 `docs/ref-jingzhe6.7/libreadtoendhook.asm`、
> 参考包 blk 样本 `samples/20527480.jingzhe6.7.blk`）。

别人的**改客户端**（非代理）完整方案，可作蓝本：

- **加载方式**：改 `libyuanshen.so` 的 **DT_NEEDED** 加 `libclienthook.so`（链接器自动加载，免改 dex）。
- **`libclienthook.so`**（4.2MB）：打包/加密的 hook 框架，由它拉起 `libreadtoendhook.so`。
- **`libreadtoendhook.so`**（55KB，And64InlineHook）：**hook `libyuanshen.so` 的 `ReadToEnd`
  （RVA `0x13d0d8ac`，6.7 专用）**，把返回的 CN 公钥字符串**原地替换成自己服务器的公钥**。
- **blk**：`DispatchUrls=["http://sdk.yuanshen.org.cn/query_region_list"]`（**域名**），`keyId=3`。
- **端点**：全部指向 `https://sdk.yuanshen.org.cn`（公网 IP `106.14.151.240`，阿里云）。
- 推论：参考包用**公网域名**，很可能**没绕域名校验，只是服务端在公网**。
  若校验要求解析到**公网 IP**，本地 `127.0.0.1` 怎么伪装都过不了。
- 其 hook 库对 7.1 **不通用**（RVA 与公钥随版本变）。

---

## 12. 工具脚本

| 脚本 | 用途 |
|---|---|
| `tools/blk_tool.py` | blk 解包 / 重打包 / 等长文本替换 |
| `tools/repack.py` `repack2.py` `repack3.py` `repack4.py` | APK zip 级重打包（保留未改条目字节与 `.so` 对齐），各版对应不同改动 |
| `tools/dex_patch2.py` | dex 内整条 URL 等长替换 + 重算 checksum/SHA1 |
| `tools/smali_patch.py` `dexstrings.py` | dex 字符串分析 / smali 辅助 |
| `tools/rsa.py` `rsa2.py` `rsa3.py` | RSA 公钥提取 / 验签尝试 |
| `tools/signbrute.py` `ysdecrypt.py` `strscan.py` `xref.py` | 签名爆破、元数据解密尝试、字符串/交叉引用扫描 |
| `tools/pp.py` | ProxyPin MCP 客户端（token 用环境变量 `PP_MCP_TOKEN`） |

---

## 13. 仓库文件清单

```
README.md                本文档
patch/
  patch_apk.py           云编译主脚本（blk+TextAsset+dex域名+登录公钥 → 改包）
  libs/baksmali.jar      dex 反编译（smali v2.5.2）
  libs/smali.jar         dex 重汇编
keystore/yspatch.keystore 签名用 keystore（alias yspatch，口令 yspatch123）
.github/workflows/build.yml  云编译工作流
docs/
  01_替换说明.txt          v1：改 TextAsset + classes3/4.dex 域名
  02_登录重定向_v2.txt      v2：baksmali 改登录域名（dex 排序坑）
  03_登录公钥_v3.txt        v3：登录公钥等长替换（修 ma-passport）
  04_参考包_惊蛰6.7_流程.md  参考方案（hook 改客户端）完整流程
  ref-jingzhe6.7/         参考包材料（libreadtoendhook 反汇编、AndroidManifest）
samples/
  20527480.orig.blk        原版 dispatch 配置 blk（无字典 LZ4）
  20527480.nip.blk         redirect4 用（nip.io 域名，等长）
  20527480.expert.blk      社区 expert（keyId=5，字典 LZ4）
  20527480.jingzhe6.7.blk  参考包 blk（域名 sdk.yuanshen.org.cn，keyId=3）
tools/                     见 §12
```

> 完整改包 APK（~500MB）**不进仓库**（超 GitHub 单文件 100MB 限制）。
> 如需分发，用 **GitHub Releases** 上传（单文件上限 2GB），或用脚本在你自己的 clone 包上现场生成。

---

## 14. 已知问题 / TODO

- [ ] **redirect4 闪退**：定位并修复（§10.3）。
- [ ] 确认 **4214 域名校验**的确切机制（在 MHY0 加密的 `global-metadata.dat` 内）。
- [ ] 若校验要求公网 IP：需 hook 客户端校验函数（参考 `libreadtoendhook.so` 思路）或解密 MHY0。
- [ ] `global-metadata.dat` 为 **MHY0** 加密（`0x208` 起为明文 IL2CPP 负载），原神 7.1 的解密常数未知。
- [ ] 设备**未 root**（无 su/magisk）⇒ 不能用 hosts / frida-server；可用 **frida-gadget 注入改包 APK**（免 root）。

---

## 变更记录

- **2026-10-13** 初版：整理协议分析、blk 格式、改包/代理路线、登录公钥替换（v3 成功）、
  4214 根因、redirect4（nip.io）闪退记录、参考包分析、工具脚本。
