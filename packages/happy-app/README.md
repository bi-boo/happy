<div align="center"><img src="/logo.png" width="200" title="Happy Coder" alt="Happy Coder"/></div>

<h1 align="center">
  Claude Code 和 Codex 的移动端与 Web 客户端
</h1>

<h4 align="center">
随时随地通过端对端加密使用 Claude Code 或 Codex。
</h4>

<div align="center">

[📱 **iOS App**](https://apps.apple.com/us/app/happy-claude-code-client/id6748571505) • [🤖 **Android App**](https://play.google.com/store/apps/details?id=com.ex3ndr.happy) • [🌐 **Web App**](https://app.happy.engineering) • [🎥 **查看演示**](https://youtu.be/GCS0OG9QMSE) • [📚 **文档**](https://happy.engineering/docs/) • [💬 **Discord**](https://discord.gg/fX9WBAhyfD)

</div>

<img width="5178" height="2364" alt="github" src="https://github.com/user-attachments/assets/14d517e9-71a8-4fcb-98ae-9ebf9f7c149f" />


<h3 align="center">
第一步：下载 App
</h3>

<div align="center">
<a href="https://apps.apple.com/us/app/happy-claude-code-client/id6748571505"><img width="135" height="39" alt="appstore" src="https://github.com/user-attachments/assets/45e31a11-cf6b-40a2-a083-6dc8d1f01291" /></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="https://play.google.com/store/apps/details?id=com.ex3ndr.happy"><img width="135" height="39" alt="googleplay" src="https://github.com/user-attachments/assets/acbba639-858f-4c74-85c7-92a4096efbf5" /></a>
</div>

<h3 align="center">
第二步：在你的电脑上安装 CLI
</h3>

```bash
curl -fsSL https://raw.githubusercontent.com/bi-boo/happy/main/install.sh | bash
```

<h3 align="center">
第三步：用 `happy` 替代 `claude` 或 `codex` 开始使用
</h3>

```bash

# 原来用: claude
# 现在用: happy

happy

# 原来用: codex
# 现在用: happy codex

happy codex

```

## 工作原理

在你的电脑上运行 `happy` 替代 `claude`，或运行 `happy codex` 替代 `codex`，通过我们的封装层启动 AI。当你想从手机控制编程 Agent 时，它会以远程模式重启会话。要切换回电脑控制，只需按下键盘上的任意键即可。

## 为什么选择 Happy Coder？

- 📱 **移动端访问 Claude Code 和 Codex** - 离开桌面时随时查看 AI 的构建进度
- 🔔 **推送通知** - Claude Code 和 Codex 需要授权或遇到错误时即时提醒你
- ⚡ **跨设备无缝切换** - 一键从手机或桌面接管控制
- 🔐 **端对端加密** - 你的代码在离开设备前始终处于加密状态
- 🛠️ **开源** - 自行审计代码，无遥测，无追踪

## 项目组件

- **[happy-cli](https://github.com/bi-boo/happy-cli)** - Claude Code 和 Codex 的命令行工具
- **[happy-server](https://github.com/bi-boo/happy-server)** - 用于加密同步的后端服务
- **happy-coder** - 本移动客户端（当前仓库）

## 关于本项目

这是一个基于 Happy Coder 的私有化部署版本。

## 文档与贡献

- **[文档网站](https://happy.engineering/docs/)** - 学习如何高效使用 Happy Coder
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - 开发环境配置，包含 iOS、Android 和 macOS 桌面版构建说明
- **[在 github.com/bi-boo/bi-boo.github.io 编辑文档](https://github.com/bi-boo/bi-boo.github.io)** - 帮助完善我们的文档和指南

## 许可证

MIT License - 详见 [LICENSE](LICENSE)。
