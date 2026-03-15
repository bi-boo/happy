# Happy Server

面向开源端到端加密 Claude Code 客户端的极简后端。

## 什么是 Happy？

Happy Server 是安全 Claude Code 客户端的同步核心。它让多台设备能够共享加密对话，同时保持完整的隐私——服务器永远看不到你的消息内容，只存储它无法解读的加密数据块。

## 功能特性

- 🔐 **零知识** - 服务器仅存储加密数据，无任何解密能力
- 🎯 **最小化接口** - 仅包含安全同步所需的核心功能，无多余设计
- 🕵️ **隐私优先** - 无数据分析、无追踪、无数据挖掘
- 📖 **开源透明** - 实现完全公开，可自行审计和部署
- 🔑 **密码学认证** - 不存储密码，仅使用公钥签名
- ⚡ **实时同步** - 基于 WebSocket 的跨设备实时同步
- 📱 **多设备支持** - 在手机、平板和电脑间无缝管理会话
- 🔔 **推送通知** - Claude Code 完成任务或需要授权时发送通知（内容加密，服务端不可见）
- 🌐 **分布式就绪** - 架构设计支持水平扩展

## 工作原理

你的 Claude Code 客户端在本地生成加密密钥，并使用 Happy Server 作为安全中继。消息在离开设备前即完成端到端加密。服务器的职责很简单：存储加密数据块，并在你的设备间实时同步。

## 服务托管

本版本默认使用自建服务器 happy.yuanfengai.cn，所有数据端到端加密。

## 使用 Docker 自托管

独立 Docker 镜像将所有内容运行在单一容器中，无需外部依赖（无需 PostgreSQL、Redis 或 S3）。

```bash
docker build -t happy-server -f Dockerfile .
```

从 monorepo 根目录运行：

```bash
docker run -p 3005:3005 \
  -e HANDY_MASTER_SECRET=<your-secret> \
  -v happy-data:/data \
  happy-server
```

使用以下组件：
- **PGlite** - 内嵌式 PostgreSQL（数据存储于 `/data/pglite`）
- **本地文件系统** - 用于文件上传（存储于 `/data/files`）
- **内存事件总线** - 无需 Redis

数据通过 `happy-data` Docker 卷持久化，容器重启后不丢失。

### 环境变量

| 变量名 | 是否必填 | 默认值 | 说明 |
|----------|----------|---------|-------------|
| `HANDY_MASTER_SECRET` | 是 | - | 用于认证和加密的主密钥 |
| `PUBLIC_URL` | 否 | `http://localhost:3005` | 发送给客户端的文件 URL 的公开基础地址 |
| `PORT` | 否 | `3005` | 服务器端口 |
| `DATA_DIR` | 否 | `/data` | 数据根目录 |
| `PGLITE_DIR` | 否 | `/data/pglite` | PGlite 数据库目录 |

### 可选：使用外部服务

如需使用外部 PostgreSQL 或 Redis 替代内嵌默认组件，可设置以下变量：

| 变量名 | 说明 |
|----------|-------------|
| `DATABASE_URL` | PostgreSQL 连接地址（替代 PGlite） |
| `REDIS_URL` | Redis 连接地址 |
| `S3_HOST` | S3/MinIO 主机地址（替代本地文件存储） |

## 开源协议

MIT - 自由使用、修改、部署于任何环境。
