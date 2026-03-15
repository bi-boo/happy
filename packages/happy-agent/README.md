# Happy Agent

远程控制 Happy Coder Agent 的 CLI 客户端。

与同时运行和控制 Agent 的 `happy-cli` 不同，`happy-agent` 只负责控制 Agent——包括创建会话、发送消息、读取历史记录、监控状态以及停止会话。

## 安装

在 monorepo 中构建：

```bash
yarn workspace happy-agent build
```

或全局链接：

```bash
cd packages/happy-agent && npm link
```

## 认证

Happy Agent 通过 QR code 进行账号认证，流程与在 Happy 移动端 App 中关联设备相同。

```bash
# 用 Happy 移动端 App 扫描 QR code 完成认证
happy-agent auth login

# 查看认证状态
happy-agent auth status

# 清除已存储的凭据
happy-agent auth logout
```

凭据存储于 `~/.happy/agent.key`。

## 命令

### 列出会话

```bash
# 列出所有会话
happy-agent list

# 只列出活跃会话
happy-agent list --active

# 以 JSON 格式输出
happy-agent list --json
```

### 会话状态

```bash
# 获取会话实时状态（支持 ID 前缀匹配）
happy-agent status <session-id>

# 以 JSON 格式输出
happy-agent status <session-id> --json
```

### 创建会话

```bash
# 创建一个带标签的新会话
happy-agent create --tag my-project

# 指定工作目录
happy-agent create --tag my-project --path /home/user/project

# 以 JSON 格式输出
happy-agent create --tag my-project --json
```

### 发送消息

```bash
# 向会话发送消息
happy-agent send <session-id> "Fix the login bug"

# 发送消息并等待 Agent 执行完成
happy-agent send <session-id> "Run the tests" --wait

# 以 JSON 格式输出
happy-agent send <session-id> "Hello" --json
```

### 消息历史

```bash
# 查看消息历史
happy-agent history <session-id>

# 限制显示最近 N 条消息
happy-agent history <session-id> --limit 10

# 以 JSON 格式输出
happy-agent history <session-id> --json
```

### 停止会话

```bash
happy-agent stop <session-id>
```

### 等待空闲

```bash
# 等待 Agent 变为空闲状态（默认超时 300 秒）
happy-agent wait <session-id>

# 自定义超时时间
happy-agent wait <session-id> --timeout 60
```

Agent 变为空闲时退出码为 0，超时时退出码为 1。

## 环境变量

- `HAPPY_SERVER_URL` - API 服务器地址（默认：`https://happy.yuanfengai.cn`）
- `HAPPY_HOME_DIR` - 凭据存储的主目录（默认：`~/.happy`）

## Session ID 匹配

所有接受 `<session-id>` 参数的命令均支持前缀匹配。你可以只提供 Session ID 的前几个字符，CLI 会自动解析出完整 ID。

## 加密

所有会话数据均经过端对端加密。新会话使用 AES-256-GCM 配合每会话独立密钥进行加密。由其他客户端创建的已有会话将根据相应的加密方案（AES-256-GCM 或旧版 NaCl secretbox）进行解密。

## 环境要求

- Node.js >= 20.0.0
- 需要 Happy 移动端 App 账号用于认证

## License

MIT
