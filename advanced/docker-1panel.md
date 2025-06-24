# 1panel

官网：https://github.com/1Panel-dev/1Panel

配置模版：[1panel模版](./yml/docker-compose-1panel.yml)

[![github.com/1panel-dev/1p...](https://images.openai.com/thumbnails/url/zKn-bHicu1mSUVJSUGylr5-al1xUWVCSmqJbkpRnoJdeXJJYkpmsl5yfq5-Zm5ieWmxfaAuUsXL0S7F0Tw7K8sgpMUsKdgoKzXA2cTUyN3IPy8mv0C3JSjEIr8wviQg3dCwyLcnIz0j3zTIMyQ2PSPErK9ctLTWydFQrBgAUninm)](https://github.com/1Panel-dev/1Panel)

下面是关于 **1Panel** 的详细介绍：

---

## 🛠️ 核心功能

* **现代化 Linux 控制面板**：1Panel 是一个开源的 Web 图形界面面板，用于高效管理 Linux 服务器。提供主机监控、文件管理、数据库（MySQL、PostgreSQL、Redis 等）管理、容器管理，甚至对接 LLM（大语言模型）操作 ([github.com][1])。
* **一键建站**：深度整合 WordPress（以及 Halo 等）、自动绑定域名、配置 SSL，简化网站部署流程，仅需“一键”操作 ([github.com][1])。
* **应用商店支持**：内置一个应用市场，可以轻松安装、升级各类优质开源软件，包括 OpenResty、MySQL、KubePi 等 ([reddit.com][2])。
* **安全可靠**：

  * 基于容器部署，降低安全风险；
  * 集成防火墙管理、日志审计功能；
  * 提供一键备份/恢复，并支持云端存储（例如 S3、Google 云等）([github.com][1])。
* **API 与 MCP 支持**：

  * 内嵌 Swagger 风格 API 文档，可用于自动化控制 ([github.com][3], [docs.1panel.hk][4])；
  * mcp-1panel 模块支持通过标准 Model Context Protocol 与外部工具（如 Windsurf、Cursor）互操作 ([github.com][5])。

---

## 🚀 快速入门

官方推荐通过以下脚本迅速安装（国内用户使用切换为 `.hk` 或 `.pro` 脚本）：

```bash
curl -sSL https://resource.1panel.pro/quick_start.sh -o quick_start.sh && bash quick_start.sh
```

脚本会自动配置所需依赖与运行环境 ([github.com][1])。

---

## 📢 社区口碑 & 安全

* GitHub 上已有 **29k+ stars**、近 3k 的 fork，是社区认可的成熟项目 ；
* Product Hunt 也给出 5/5 的高评价，用户称：“比 Webmin 更好” ([producthunt.com][6])；
* Reddit 上自托管用户称其代码可信，社区活跃，问题管理规范 ；
* 曾发现一处“密码验证出现计时攻击风险”的安全报告，团队正在跟进修复 ([deps.dev][7])。

---

## 📦 生态与扩展

* **mcp-1panel**：官方实现的 MCP Server，可用作命令行/HTTP 接口，与 DevOps 工具连通 ([github.com][5])；
* **App Store 仓库**：官方维护常用开源应用列表，Docker 镜像形式便于部署 ；
* 相关项目包括 **KubePi**（Kubernetes 面板）、**MaxKB**（企业知识库系统）等，共享同一生态 ([github.com][8])。
* [青龙定时任务管理器面板](https://qinglong.online/)
---

## ✅ 总结

**适合人群**

* 个人开发者、团队或中小规模企业
* 需要简洁、高效、图形化 Linux 运维管理工具
* 追求自动化部署与安全性的用户群

**突出优势**

* 功能齐全，对接容器、数据库、备份、证书、监控等
* 图形化操作替代重复命令，降低入门门槛
* 活跃社区+频繁更新+多平台支持（ARM、AMD 等）

---

如果你正想替代传统面板（如 Webmin、cPanel）并构建轻量自托管平台，**1Panel** 是个功能丰富、用户评价高的不错选择。如果有安装配置或对某项功能想深入了解，我也可以继续帮你挖掘 👍

[1]: https://github.com/1Panel-dev/1Panel?utm_source=chatgpt.com "1Panel provides an intuitive web interface and MCP Server ... - GitHub"
[2]: https://www.reddit.com/r/selfhosted/comments/1hi7ola/introducing_1panel_a_webbased_linux_server/?utm_source=chatgpt.com "Introducing 1Panel - A web-based Linux Server Management Tool ..."
[3]: https://github.com/1Panel-dev/1Panel/releases?utm_source=chatgpt.com "Releases · 1Panel-dev/1Panel - GitHub"
[4]: https://docs.1panel.hk/dev_manual/api_manual/?utm_source=chatgpt.com "docs.1panel.hk/dev_manua..."
[5]: https://github.com/1Panel-dev/mcp-1panel?utm_source=chatgpt.com "mcp-1panel is an implementation of the Model Context ... - GitHub"
[6]: https://www.producthunt.com/products/1panel/reviews?review=1034656&utm_source=chatgpt.com "producthunt.com/products..."
[7]: https://deps.dev/go/github.com%2F1Panel-dev%2F1Panel/v1.5.0?utm_source=chatgpt.com "github.com/1Panel-dev/1Panel | Go | Open Source Insights"
[8]: https://github.com/1Panel-dev?utm_source=chatgpt.com "1Panel-dev - GitHub"
