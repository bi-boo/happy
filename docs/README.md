# Happy 文档

本文件夹记录了 Happy 的内部工作原理，重点涵盖协议、后端架构、部署方式以及 CLI 工具。从这里开始阅读。

## 目录索引
- protocol.md：Wire 协议（WebSocket）、payload 格式、消息排序与并发规则。
- api.md：HTTP 接口与身份认证流程。
- encryption.md：加密边界与链路层编码方式。
- backend-architecture.md：后端内部结构、数据流及核心子系统。
- deployment.md：后端部署方式与所需基础设施。
- cli-architecture.md：CLI 与 daemon 的架构，以及它们与服务端的交互方式。
- session-protocol.md：统一加密聊天事件协议。
- session-protocol-claude.md：Claude 专属的 session-protocol 流程（本地 vs 远程 launcher、去重与重启机制）。
- permission-resolution.md：跨 App 和 CLI 的基于状态的权限模式解析（含沙箱行为）。
- happy-wire.md：共享 wire schemas/types 包及迁移说明。

## 约定
- 路径和字段名以 `packages/happy-server` 中的当前实现为准。
- 示例仅供参考；规范来源以代码为准。
