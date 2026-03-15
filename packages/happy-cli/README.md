# Happy

随时随地编程 —— 用手机远程控制 AI 编程 Agent。

免费、开源，随时随地写代码。

## 安装

```bash
curl -fsSL https://raw.githubusercontent.com/bi-boo/happy/main/install.sh | bash
```

## 从源码运行

克隆仓库后执行：

```bash
# 在仓库根目录
yarn cli --help

# 在 package 目录
yarn cli --help
```

## 使用方法

### Claude（默认）

```bash
happy
```

执行后将会：
1. 启动一个 Claude Code 会话
2. 显示 QR code，供手机端扫码连接
3. 实现 Claude Code 与手机 App 之间的实时会话共享

### Gemini

```bash
happy gemini
```

启动带有远程控制能力的 Gemini CLI 会话。

**首次使用需先授权：**
```bash
# 使用 Google 账号登录
happy connect gemini
```

## 命令列表

### 主命令

- `happy` – 启动 Claude Code 会话（默认）
- `happy gemini` – 启动 Gemini CLI 会话
- `happy codex` – 启动 Codex 模式
- `happy acp` – 启动通用 ACP 兼容 Agent

### 工具命令

- `happy auth` – 管理身份认证
- `happy connect` – 将 AI 服务商 API Key 存储到 Happy 云端
- `happy sandbox` – 配置沙盒运行时限制
- `happy notify` – 向你的设备发送推送通知
- `happy daemon` – 管理后台服务
- `happy doctor` – 系统诊断与故障排查

### connect 子命令

```bash
happy connect gemini     # 使用 Google 账号授权 Gemini
happy connect claude     # 使用 Anthropic 账号授权
happy connect codex      # 使用 OpenAI 账号授权
happy connect status     # 查看所有服务商的连接状态
```

### gemini 子命令

```bash
happy gemini                      # 启动 Gemini 会话
happy gemini model set <model>    # 设置默认模型
happy gemini model get            # 查看当前模型
happy gemini project set <id>     # 设置 Google Cloud Project ID（企业账号使用）
happy gemini project get          # 查看当前 Google Cloud Project ID
```

**可用模型：** `gemini-2.5-pro`、`gemini-2.5-flash`、`gemini-2.5-flash-lite`

### 通用 ACP 命令

```bash
happy acp gemini                     # 运行内置 Gemini ACP 命令
happy acp opencode                   # 运行内置 OpenCode ACP 命令
happy acp opencode --verbose         # 包含原始后端/封包日志
happy acp -- custom-agent --flag     # 直接运行任意 ACP 兼容命令
```

### sandbox 子命令

```bash
happy sandbox configure  # 交互式沙盒配置向导
happy sandbox status     # 查看当前沙盒配置
happy sandbox disable    # 禁用沙盒
```

## 选项

### Claude 选项

- `-m, --model <model>` - 指定 Claude 模型（默认：sonnet）
- `-p, --permission-mode <mode>` - 权限模式：auto、default 或 plan
- `--claude-env KEY=VALUE` - 为 Claude Code 设置环境变量
- `--claude-arg ARG` - 向 Claude CLI 传递额外参数

### 全局选项

- `-h, --help` - 显示帮助信息
- `-v, --version` - 显示版本号
- `--no-sandbox` - 在本次 Claude/Codex 运行中禁用沙盒

## 环境变量

### Happy 配置

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `HAPPY_SERVER_URL` | 自定义服务器地址 | `https://happy.yuanfengai.cn` |
| `HAPPY_WEBAPP_URL` | 自定义 Web App 地址 | `https://app.happy.engineering` |
| `HAPPY_HOME_DIR` | Happy 数据的自定义主目录 | `~/.happy` |
| `HAPPY_DISABLE_CAFFEINATE` | 禁用 macOS 系统休眠防护（设为 `true`、`1` 或 `yes`） | — |
| `HAPPY_EXPERIMENTAL` | 启用实验性功能（设为 `true`、`1` 或 `yes`） | — |

### Gemini 配置

| 变量名 | 说明 |
|--------|------|
| `GEMINI_MODEL` | 覆盖默认 Gemini 模型 |
| `GOOGLE_CLOUD_PROJECT` | Google Cloud Project ID（企业账号必填） |

## Gemini 授权说明

### 个人 Google 账号

个人 Gmail 账号开箱即用：

```bash
happy connect gemini
happy gemini
```

### Google Workspace 企业账号

Google Workspace（组织）账号需要配置 Google Cloud Project：

1. 在 [Google Cloud Console](https://console.cloud.google.com/) 创建项目
2. 启用 Gemini API
3. 设置 Project ID：

```bash
happy gemini project set your-project-id
```

或通过环境变量设置：
```bash
GOOGLE_CLOUD_PROJECT=your-project-id happy gemini
```

**参考文档：** https://goo.gle/gemini-cli-auth-docs#workspace-gca

## 系统要求

- Node.js >= 20.0.0

### Claude 依赖

- 已安装并登录 Claude CLI（`claude` 命令可在 PATH 中找到）

### Gemini 依赖

- 已安装 Gemini CLI（`npm install -g @google/gemini-cli`）
- 已通过 `happy connect gemini` 完成 Google 账号授权
