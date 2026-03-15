<div align="center"><img src="/.github/logotype-dark.png" width="400" title="Happy Coder" alt="Happy Coder"/></div>

<h1 align="center">
  Claude Code & Codex 的移动端与网页客户端
</h1>

<h4 align="center">
随时随地使用 Claude Code 或 Codex，全程端对端加密。
</h4>

<div align="center">

[📱 **iOS App**](https://apps.apple.com/us/app/happy-claude-code-client/id6748571505) • [🤖 **Android App**](https://play.google.com/store/apps/details?id=com.ex3ndr.happy) • [🌐 **Web App**](https://app.happy.engineering) • [🎥 **查看演示**](https://youtu.be/GCS0OG9QMSE) • [📚 **文档**](https://happy.engineering/docs/) • [💬 **Discord**](https://discord.gg/fX9WBAhyfD)

</div>

<img width="5178" height="2364" alt="github" src="/.github/header.png" />


<h3 align="center">
第一步：下载手机 App
</h3>

<div align="center">
<a href="https://apps.apple.com/us/app/happy-claude-code-client/id6748571505"><img width="135" height="39" alt="appstore" src="https://github.com/user-attachments/assets/45e31a11-cf6b-40a2-a083-6dc8d1f01291" /></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://play.google.com/store/apps/details?id=com.ex3ndr.happy"><img width="135" height="39" alt="googleplay" src="https://github.com/user-attachments/assets/acbba639-858f-4c74-85c7-92a4096efbf5" /></a>
</div>

> 安装后打开 App，点击右上角服务器图标，将服务器地址设置为 `https://happy.yuanfengai.cn`

<h3 align="center">
第二步：在电脑上安装 CLI
</h3>

```bash
curl -fsSL https://raw.githubusercontent.com/bi-boo/happy/main/install.sh | bash
```

<h3 align="center">
第三步：启动并扫码配对
</h3>

```bash
# 启动 happy（替代 claude 命令）
happy

# 或以 Codex 模式启动（替代 codex 命令）
happy codex
```

启动后终端会显示二维码，用手机 App 扫码即可配对连接。

<div align="center"><img src="/.github/mascot.png" width="200" title="Happy Coder" alt="Happy Coder"/></div>

## 工作原理

在电脑上，用 `happy` 替代 `claude`，或用 `happy codex` 替代 `codex`，通过我们的包装器启动 AI。当你想从手机控制编程 Agent 时，它会以远程模式重新启动会话。如需切换回电脑操控，只需在键盘上按任意键即可。

## 🔥 为什么选择 Happy Coder？

- 📱 **在移动端访问 Claude Code 和 Codex** - 离开座位时也能随时查看 AI 的构建进度
- 🔔 **推送通知** - Claude Code 和 Codex 需要授权或遇到错误时立即收到提醒
- ⚡ **设备间即时切换** - 一键从手机或电脑接管控制权
- 🔐 **端对端加密** - 你的代码在设备之间传输时始终保持加密
- 🛠️ **开源** - 自行审计代码，无遥测，无追踪

## 📦 项目组成

- **[Happy App](https://github.com/bi-boo/happy/tree/main/packages/happy-app)** - Web UI + 移动端客户端（Expo）
- **[Happy CLI](https://github.com/bi-boo/happy/tree/main/packages/happy-cli)** - Claude Code 和 Codex 的命令行界面
- **[Happy Agent](https://github.com/bi-boo/happy/tree/main/packages/happy-agent)** - 远程 Agent 控制 CLI（创建、发送、监控会话）
- **[Happy Server](https://github.com/bi-boo/happy/tree/main/packages/happy-server)** - 用于加密同步的后端服务器

## 🏠 关于本项目

这是一个基于 Happy Coder 开源项目的私有化部署版本，默认连接自建服务器 happy.yuanfengai.cn，用于远程控制 Mac 上的 AI 编程助手。

## 📚 文档与贡献

- **[文档网站](https://happy.engineering/docs/)** - 学习如何高效使用 Happy Coder
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - 开发环境搭建，包含 iOS、Android 和 macOS 桌面端构建说明
- **[在 github.com/bi-boo/happy 上编辑文档](https://github.com/bi-boo/happy)** - 协助改进文档和使用指南

## 许可证

MIT License - 详见 [LICENSE](LICENSE)。
