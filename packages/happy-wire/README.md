# @slopus/happy-wire

Happy 客户端与服务的规范 wire 规格包。

本包以 TypeScript 类型 + Zod schemas 的形式定义共享 wire 契约，设计上保持精简，仅关注协议层数据。

## 快速示例（旧格式 vs 新格式）

旧格式与新格式均通过加密 session 消息传输。

旧格式示例（解密后的 payload）：

```json
{
  "role": "user",
  "content": {
    "type": "text",
    "text": "fix the failing test"
  },
  "meta": {
    "sentFrom": "mobile"
  }
}
```

```json
{
  "role": "agent",
  "content": {
    "type": "output",
    "data": {
      "type": "message",
      "message": "I found the issue in api/session.ts"
    }
  },
  "meta": {
    "sentFrom": "cli"
  }
}
```

新 session 协议格式示例（解密后的 payload）：

```json
{
  "role": "session",
  "content": {
    "id": "msg_01",
    "time": 1739347230000,
    "role": "agent",
    "turn": "turn_01",
    "ev": {
      "t": "text",
      "text": "I found the issue in api/session.ts"
    }
  },
  "meta": {
    "sentFrom": "cli"
  }
}
```

现代 session 协议用户信封（解密后的 payload）：

```json
{
  "role": "session",
  "content": {
    "id": "msg_legacy_user_01",
    "time": 1739347231000,
    "role": "user",
    "ev": {
      "t": "text",
      "text": "fix the failing test"
    }
  },
  "meta": {
    "sentFrom": "cli"
  }
}
```

协议不变式：
- 外层 `role = "session"` 标志着现代 session 协议 payload。
- `content` 内部，信封 `role` 只能为 `"user"` 或 `"agent"`。

Session 协议发送灰度开关（`ENABLE_SESSION_PROTOCOL_SEND`）：
- 发送方发出现代 session 协议用户 payload（`role = "session"`，`content.role = "user"`）。
- 默认（禁用）：App 消费旧格式用户 payload（`role = "user"`，`content.type = "text"`），丢弃现代用户 payload。
- 启用后：App 消费现代用户 payload，丢弃旧格式用户 payload。
- 真值：`1`、`true`、`yes`（不区分大小写）。

Wire 层加密容器（旧格式和新格式相同）：

```json
{
  "id": "msg-db-row-id",
  "seq": 101,
  "localId": null,
  "content": {
    "t": "encrypted",
    "c": "BASE64_ENCRYPTED_PAYLOAD"
  },
  "createdAt": 1739347230000,
  "updatedAt": 1739347230000
}
```

## 用途

`@slopus/happy-wire` 集中定义以下内容：
- 加密消息/更新 payload
- session 协议信封与事件流
- 用于创建合法 session 信封的辅助函数

目标是让 CLI/App/服务端/Agent 保持相同的 wire 契约，避免 schema 漂移。

## 包标识

- 包名：`@slopus/happy-wire`
- Workspace 路径：`packages/happy-wire`
- 入口：`src/index.ts`
- 运行时依赖：`zod`、`@paralleldrive/cuid2`

## 公开导出

`src/index.ts` 导出以下模块的全部内容：
- `src/messages.ts`
- `src/legacyProtocol.ts`
- `src/sessionProtocol.ts`

### `messages.ts` 导出内容

Schemas 及推导类型：
- `SessionMessageContentSchema`
- `SessionMessage`
- `SessionMessageSchema`
- `MessageMetaSchema`
- `MessageMeta`
- `SessionProtocolMessageSchema`
- `SessionProtocolMessage`
- `MessageContentSchema`
- `MessageContent`
- `VersionedEncryptedValueSchema`
- `VersionedEncryptedValue`
- `VersionedNullableEncryptedValueSchema`
- `VersionedNullableEncryptedValue`
- `UpdateNewMessageBodySchema`
- `UpdateNewMessageBody`
- `UpdateSessionBodySchema`
- `UpdateSessionBody`
- `VersionedMachineEncryptedValueSchema`
- `VersionedMachineEncryptedValue`
- `UpdateMachineBodySchema`
- `UpdateMachineBody`
- `CoreUpdateBodySchema`
- `CoreUpdateBody`
- `CoreUpdateContainerSchema`
- `CoreUpdateContainer`

兼容性别名：
- `ApiMessageSchema` -> `SessionMessageSchema`
- `ApiMessage` -> `SessionMessage`
- `ApiUpdateNewMessageSchema` -> `UpdateNewMessageBodySchema`
- `ApiUpdateNewMessage` -> `UpdateNewMessageBody`
- `ApiUpdateSessionStateSchema` -> `UpdateSessionBodySchema`
- `ApiUpdateSessionState` -> `UpdateSessionBody`
- `ApiUpdateMachineStateSchema` -> `UpdateMachineBodySchema`
- `ApiUpdateMachineState` -> `UpdateMachineBody`
- `UpdateBodySchema` -> `UpdateNewMessageBodySchema`
- `UpdateBody` -> `UpdateNewMessageBody`
- `UpdateSchema` -> `CoreUpdateContainerSchema`
- `Update` -> `CoreUpdateContainer`

### `legacyProtocol.ts` 导出内容

Schemas 及推导类型：
- `UserMessageSchema`
- `UserMessage`
- `AgentMessageSchema`
- `AgentMessage`
- `LegacyMessageContentSchema`
- `LegacyMessageContent`

### `sessionProtocol.ts` 导出内容

Schemas 及推导类型：
- `sessionRoleSchema`
- `SessionRole`
- `sessionTextEventSchema`
- `sessionServiceMessageEventSchema`
- `sessionToolCallStartEventSchema`
- `sessionToolCallEndEventSchema`
- `sessionFileEventSchema`
- `sessionTurnStartEventSchema`
- `sessionStartEventSchema`
- `sessionTurnEndStatusSchema`
- `SessionTurnEndStatus`
- `sessionTurnEndEventSchema`
- `sessionStopEventSchema`
- `sessionEventSchema`
- `SessionEvent`
- `sessionEnvelopeSchema`
- `SessionEnvelope`
- `CreateEnvelopeOptions`
- `createEnvelope(...)`

## Wire 类型规格

## 通用基础规则

以下是 schema 层面的要求，而非建议。

- `id`、`sid`、`machineId`、`call`、`name`、`title`、`description`、`ref`：`string`
- `seq`、`createdAt`、`updatedAt`、`size`、`width`、`height`、`version`、`activeAt`：`number`
- 所有可为 null 的字段均明确标注 `.nullable()`。
- 所有可选字段均明确标注 `.optional()`。
- `.nullish()` 表示 `undefined | null | <type>`。

## 消息/更新规格（`messages.ts`）

### `SessionMessageContentSchema`

```ts
{
  t: 'encrypted';
  c: string;
}
```

含义：
- `t` 是值为 `'encrypted'` 的严格判别符。
- `c` 是编码为字符串的加密 payload 字节（当前通常为 base64）。

### `SessionMessageSchema`

```ts
{
  id: string;
  seq: number;
  localId?: string | null;
  content: SessionMessageContent;
  createdAt: number;
  updatedAt: number;
}
```

注意：
- `localId` 使用 `.nullish()`，以兼容不同的生产者。
- 在本共享 schema 中，`createdAt` 和 `updatedAt` 为必填字段。

### `MessageMetaSchema`

```ts
{
  sentFrom?: string;
  permissionMode?: 'default' | 'acceptEdits' | 'bypassPermissions' | 'plan' | 'read-only' | 'safe-yolo' | 'yolo';
  model?: string | null;
  fallbackModel?: string | null;
  customSystemPrompt?: string | null;
  appendSystemPrompt?: string | null;
  allowedTools?: string[] | null;
  disallowedTools?: string[] | null;
  displayText?: string;
}
```

## 旧格式解密 payload 规格（`legacyProtocol.ts`）

### `UserMessageSchema`（旧格式解密 payload）

```ts
{
  role: 'user';
  content: {
    type: 'text';
    text: string;
  };
  localKey?: string;
  meta?: MessageMeta;
}
```

### `AgentMessageSchema`（旧格式解密 payload）

```ts
{
  role: 'agent';
  content: {
    type: string;
    [key: string]: unknown;
  };
  meta?: MessageMeta;
}
```

### `LegacyMessageContentSchema`

基于 `role` 的判别联合类型：
- `'user'` -> `UserMessageSchema`
- `'agent'` -> `AgentMessageSchema`

## 顶层解密 payload 规格（`messages.ts`）

### `SessionProtocolMessageSchema`（现代解密 payload 包装器）

```ts
{
  role: 'session';
  content: SessionEnvelope;
  meta?: MessageMeta;
}
```

### `MessageContentSchema`

基于顶层 `role` 的判别联合类型：
- `'user'` -> `UserMessageSchema`（旧格式）
- `'agent'` -> `AgentMessageSchema`（旧格式）
- `'session'` -> `SessionProtocolMessageSchema`（现代格式）

## 消息/更新规格（`messages.ts`）续

### `VersionedEncryptedValueSchema`

```ts
{
  version: number;
  value: string;
}
```

用于加密的、带版本跟踪的 blob，存在时不可为 null。

### `VersionedNullableEncryptedValueSchema`

```ts
{
  version: number;
  value: string | null;
}
```

用于 payload 存在时可被有意重置为 null，同时保留版本号的场景。

### `VersionedMachineEncryptedValueSchema`

```ts
{
  version: number;
  value: string;
}
```

机器更新变体，结构与 `VersionedEncryptedValueSchema` 等效。

### `UpdateNewMessageBodySchema`

```ts
{
  t: 'new-message';
  sid: string;
  message: SessionMessage;
}
```

### `UpdateSessionBodySchema`

```ts
{
  t: 'update-session';
  id: string;
  metadata?: VersionedEncryptedValue | null;
  agentState?: VersionedNullableEncryptedValue | null;
}
```

重要区别：
- `metadata.value` 在 metadata 块存在时为 `string`。
- `agentState.value` 在 agentState 块存在时可为 `string` 或 `null`。

### `UpdateMachineBodySchema`

```ts
{
  t: 'update-machine';
  machineId: string;
  metadata?: VersionedMachineEncryptedValue | null;
  daemonState?: VersionedMachineEncryptedValue | null;
  active?: boolean;
  activeAt?: number;
}
```

### `CoreUpdateBodySchema`

基于 `t` 的判别联合类型，恰好包含 3 个变体：
- `'new-message'`
- `'update-session'`
- `'update-machine'`

### `CoreUpdateContainerSchema`

```ts
{
  id: string;
  seq: number;
  body: CoreUpdateBody;
  createdAt: number;
}
```

## Session 协议规格（`sessionProtocol.ts`）

## Role

### `sessionRoleSchema`

```ts
'user' | 'agent'
```

Role 含义：
- `'user'`：用户发起的信封。
- `'agent'`：Agent 发起的信封。

## 事件变体

`sessionEventSchema` 是基于 `t` 的判别联合类型，共 9 个变体。

### 1) 文本事件

```ts
{
  t: 'text';
  text: string;
  thinking?: boolean;
}
```

### 2) 服务事件

```ts
{
  t: 'service';
  text: string;
}
```

### 3) 工具调用开始事件

```ts
{
  t: 'tool-call-start';
  call: string;
  name: string;
  title: string;
  description: string;
  args: Record<string, unknown>;
}
```

### 4) 工具调用结束事件

```ts
{
  t: 'tool-call-end';
  call: string;
}
```

### 5) 文件事件

```ts
{
  t: 'file';
  ref: string;
  name: string;
  size: number;
  image?: {
    width: number;
    height: number;
    thumbhash: string;
  };
}
```

### 6) Turn 开始事件

```ts
{
  t: 'turn-start';
}
```

### 7) 启动事件

```ts
{
  t: 'start';
  title?: string;
}
```

### 8) Turn 结束事件

```ts
{
  t: 'turn-end';
  status: 'completed' | 'failed' | 'cancelled';
}
```

### 9) 停止事件

```ts
{
  t: 'stop';
}
```

## 信封

### `sessionEnvelopeSchema`

```ts
{
  id: string;
  time: number;
  role: 'user' | 'agent';
  turn?: string;
  subagent?: string; // 存在时必须通过 cuid2 校验
  ev: SessionEvent;
}
```

附加校验（`superRefine`）：
- 若 `ev.t === 'service'`，则 `role` 必须为 `'agent'`。
- 若 `ev.t === 'start'` 或 `ev.t === 'stop'`，则 `role` 必须为 `'agent'`。
- 若 `subagent` 存在，则必须满足 `isCuid(...)`。

## 辅助函数契约

### `createEnvelope(role, ev, opts?)`

输入：
- `role: SessionRole`
- `ev: SessionEvent`
- `opts?: { id?: string; time?: number; turn?: string; subagent?: string }`

行为：
- 若 `opts.id` 缺失，使用 `createId()` 生成 id。
- 若 `opts.time` 缺失，将 `time` 设为 `Date.now()`。
- 仅当提供了 `turn` 时才包含该字段。
- 仅当提供了 `subagent` 时才包含该字段。

输出：
- 返回经 `sessionEnvelopeSchema` 解析后的 `SessionEnvelope`。
- 遇到非法组合时抛出异常（例如 `role = 'user'` 与 `ev.t = 'service'` 同时出现）。

## 规范 JSON 示例

## 包含 `new-message` 的更新容器

```json
{
  "id": "upd-1",
  "seq": 100,
  "createdAt": 1739347200000,
  "body": {
    "t": "new-message",
    "sid": "session-1",
    "message": {
      "id": "msg-1",
      "seq": 55,
      "localId": null,
      "content": {
        "t": "encrypted",
        "c": "Zm9v"
      },
      "createdAt": 1739347199000,
      "updatedAt": 1739347199000
    }
  }
}
```

### 解密后的 `new-message` 内容示例

`message.content.c`（密文）解密后，session 协议消息的 payload 如下：

```json
{
  "role": "session",
  "content": {
    "id": "env_01",
    "time": 1739347232000,
    "role": "agent",
    "turn": "turn_01",
    "ev": {
      "t": "text",
      "text": "I found 3 TODOs."
    }
  },
  "meta": {
    "sentFrom": "cli"
  }
}
```

关于用户文本迁移行为：
- 客户端只发出现代 payload（`role = "session"`，`content.role = "user"`）。
- 若 `ENABLE_SESSION_PROTOCOL_SEND` 禁用，App 继续消费旧格式 payload，丢弃现代 payload。
- 若 `ENABLE_SESSION_PROTOCOL_SEND` 启用，App 消费现代 payload，丢弃旧格式 payload。

## 包含 `update-session` 的更新容器

```json
{
  "id": "upd-2",
  "seq": 101,
  "createdAt": 1739347210000,
  "body": {
    "t": "update-session",
    "id": "session-1",
    "metadata": {
      "version": 8,
      "value": "BASE64..."
    },
    "agentState": {
      "version": 13,
      "value": null
    }
  }
}
```

## 包含 `update-machine` 的更新容器

```json
{
  "id": "upd-3",
  "seq": 102,
  "createdAt": 1739347220000,
  "body": {
    "t": "update-machine",
    "machineId": "machine-1",
    "metadata": {
      "version": 2,
      "value": "BASE64..."
    },
    "daemonState": {
      "version": 3,
      "value": "BASE64..."
    },
    "active": true,
    "activeAt": 1739347220000
  }
}
```

## Session 协议信封

```json
{
  "id": "x8s1k2...",
  "role": "agent",
  "turn": "turn-42",
  "ev": {
    "t": "turn-start"
  }
}
```

## 解析/校验用法

```ts
import {
  CoreUpdateContainerSchema,
  sessionEnvelopeSchema,
} from '@slopus/happy-wire';

const maybeUpdate = CoreUpdateContainerSchema.safeParse(input);
if (!maybeUpdate.success) {
  // 非法的 update payload
}

const maybeEnvelope = sessionEnvelopeSchema.safeParse(envelopeInput);
if (!maybeEnvelope.success) {
  // 非法的 envelope/event payload
}
```

## 构建与发布规格

`package.json` 契约：
- `main`：`./dist/index.cjs`
- `module`：`./dist/index.mjs`
- `types`：`./dist/index.d.cts`
- `exports["."]` 同时提供 CJS 和 ESM 入口及类型路径。

构建脚本：
- `shx rm -rf dist && npx tsc --noEmit && pkgroll`

测试：
- 使用 `vitest` 针对 `src/*.test.ts` 运行

发布门控：
- `prepublishOnly` 执行构建 + 测试

发布文件：
- `dist`
- `package.json`
- `README.md`

## Monorepo 构建依赖行为

在本仓库中，消费方 workspace 通过指向 `dist/*` 的包导出来引入 `@slopus/happy-wire`。

这意味着在全新 checkout 时：
1. 先构建 wire：`yarn workspace @slopus/happy-wire build`
2. 再构建/类型检查依赖方。

发布到 npm 后，依赖方从已发布的 tarball 中消费预构建产物。

## 变更策略

修改 wire schemas 时：
- 优先采用新增式变更，以保持与旧版消费者的兼容性。
- 将判别符值（`t`）视为协议级 API，避免破坏性重命名。
- 在本 README 中记录语义变更。
- 在依赖新 schema 行为的下游发布前，先升级包版本号。

## 开发命令

```bash
# 在仓库根目录执行
yarn workspace @slopus/happy-wire build
yarn workspace @slopus/happy-wire test
```

## 发布命令（维护者）

```bash
# 在仓库根目录交互式选择发布目标
yarn release

# 直接调用发布
yarn workspace @slopus/happy-wire release
```

使用与 monorepo 中其他可发布库相同的 `release-it` 流程准备发布产物。
