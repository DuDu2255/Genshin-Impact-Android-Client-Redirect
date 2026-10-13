# docs 索引

本目录收录原神 7.1 私服重定向 / 改包的全部文档。

| 文件 | 内容 |
|---|---|
| [01_替换说明_v1.txt](01_替换说明_v1.txt) | v1：只改 assets（TextAsset 域名），**未改 dex**（失败版，留档） |
| [02_登录重定向_v2.txt](02_登录重定向_v2.txt) | v2：baksmali 改 dex 登录域名（记录 string_ids 排序坑） |
| [03_登录公钥_v3.txt](03_登录公钥_v3.txt) | v3：登录 RSA 公钥**等长替换**（修 ma-passport 解不开） |
| [04_参考包_惊蛰6.7_流程.md](04_参考包_惊蛰6.7_流程.md) | 参考方案：**hook 改客户端**完整流程（DT_NEEDED + inline hook ReadToEnd） |
| [reference/](reference/) | 参考包材料：`libreadtoendhook.asm`（反汇编）、`AndroidManifest.xml` |

> 项目总说明见仓库根目录 [`README.md`](../README.md)。
> 云编译改包管线见 [`patch/`](../patch/) 与 [`.github/workflows/build.yml`](../.github/workflows/build.yml)。
