# Happy i18n（基于对象的实现方式）

一个类型安全的国际化系统，采用基于对象的方式，使用函数和常量，通过熟悉的 `t('key', params)` API 格式访问。

## 概述

本实现**不依赖任何外部库**，提供以下能力：
- **完整的 TypeScript 类型安全**，支持 IntelliSense 自动补全
- **对象参数**，严格类型约束：`t('welcome', { name: 'Steve' })`
- **混合值类型**：同一对象中可同时使用字符串常量和函数
- **智能复数处理**及内置于翻译函数中的复杂逻辑
- **编译期校验**键名与参数结构

## 架构设计

### 翻译值的类型

翻译值可以是以下两种之一：
1. **字符串常量**：`'Cancel'`，用于静态文本
2. **函数**：`({ name }: { name: string }) => \`Welcome, ${name}!\``，用于动态文本

### 类型安全保障
- **键名校验**：只能使用已存在的键
- **参数强制检查**：必填/可选参数均经过类型检查
- **对象结构校验**：参数对象必须符合预期结构
- **返回值类型保证**：始终返回字符串

## 使用示例

### 基础用法

```typescript
import { t } from '@/text';

// ✅ 简单常量（无参数）
t('common.cancel')              // "Cancel"
t('settings.title')             // "Settings"
t('session.connected')          // "Connected"

// ✅ 带必填对象参数的函数
t('common.welcome', { name: 'Steve' })           // "Welcome, Steve!"
t('common.itemCount', { count: 5 })              // "5 items"
t('time.minutesAgo', { count: 1 })               // "1 minute ago"

// ✅ 多个参数
t('errors.fieldError', { field: 'Email', reason: 'Invalid format' })
t('auth.loginAttempt', { attempt: 2, maxAttempts: 3 })

// ✅ 可选参数
t('time.at', { time: '3:00 PM' })                // "3:00 PM"
t('time.at', { time: '3:00 PM', date: 'Monday' }) // "3:00 PM on Monday"
```

### 高级用法

```typescript
// 带多个参数的复杂逻辑
t('session.summary', { files: 3, messages: 10, duration: 5 })
// → "3 files, 10 messages in 5 minutes"

// 智能文件大小格式化
t('files.fileSize', { bytes: 1536 })  // "2 KB"
t('files.fileSize', { bytes: 500 })   // "500 B"

// 带条件逻辑的 Git 状态
t('git.branchStatus', { branch: 'main', ahead: 2, behind: 0 })
// → "On branch main, 2 commits ahead"

// 严格枚举类型约束
t('common.greeting', { name: 'Steve', time: 'morning' })  // time 必须为 'morning' | 'afternoon' | 'evening'
```

### 类型安全示例

```typescript
// ❌ 以下用法会导致 TypeScript 报错：
t('common.cancel', { extra: 'param' })   // 错误：期望 0 个参数
t('common.welcome')                      // 错误：缺少必填参数
t('common.welcome', { wrongKey: 'x' })   // 错误：对象必须包含 'name' 属性
t('common.welcome', { name: 123 })       // 错误：'name' 必须为字符串
t('invalid.key')                         // 错误：键名不存在
```

## 文件结构

### `_default.ts`
包含混合字符串/函数值的主翻译对象：

```typescript
export const en = {
    common: {
        cancel: 'Cancel',                    // 字符串常量
        welcome: ({ name }: { name: string }) => `Welcome, ${name}!`,  // 函数
        itemCount: ({ count }: { count: number }) =>  // 智能复数处理
            count === 1 ? '1 item' : `${count} items`,
    },
    // ... 更多分类
} as const;
```

### `index.ts`
包含 `t` 函数和工具方法的主模块：
- `t()` - 带严格类型约束的主翻译函数
- `hasTranslation()` - 检查键名是否存在
- `getAllTranslationKeys()` - 获取所有可用键名（开发用）
- `getTranslationValue()` - 获取原始值（调试用）

## 核心优势

### 1. **熟悉的 API**
使用开发者熟悉的标准 `t('key', params)` 格式。

### 2. **极致类型安全**
```typescript
// TypeScript 精确知道每个键需要哪些参数
type WelcomeParams = TranslationParams<'common.welcome'>;  // { name: string }
type CancelParams = TranslationParams<'common.cancel'>;    // void
```

### 3. **对象参数**
简洁、自解释的参数语法：
```typescript
// 不使用位置参数：t('greeting', 'Steve', 'morning')
// 使用命名对象：t('greeting', { name: 'Steve', time: 'morning' })
```

### 4. **逻辑内置于翻译函数**
复杂的格式化与复数处理逻辑与文本放在一起：
```typescript
fileSize: ({ bytes }: { bytes: number }) => {
    if (bytes < 1024) return `${bytes} B`;
    if (bytes < 1024 * 1024) return `${Math.round(bytes / 1024)} KB`;
    return `${Math.round(bytes / (1024 * 1024))} MB`;
}
```

### 5. **性能优异**
- 无需解析字符串插值
- 直接函数调用
- 支持 tree-shaking（未使用的翻译可被消除）
- 无外部依赖

### 6. **开发体验友好**
- 完整的 IntelliSense 支持
- 编译期错误捕获
- 参数名自解释
- 工具函数辅助调试

## 迁移指南

从基于插值的系统迁移时：

```typescript
// 旧方式：字符串插值
t('welcome', { name: 'Steve' })  // 运行时解析 "{name}"

// 新方式：相同 API，改为函数实现
t('welcome', { name: 'Steve' })  // 直接函数调用，结果相同
```

API 保持不变，同时获得：
- 更好的性能（无需解析）
- 更强的类型约束（对象结构校验）
- 更强的灵活性（函数中可编写复杂逻辑）

## 新增翻译

1. **在 `_default.ts` 中添加**：
```typescript
// 字符串常量
newConstant: 'My New Text',

// 带参数的函数
newFunction: ({ user, count }: { user: string; count: number }) =>
    `Hello ${user}, you have ${count} items`,
```

2. **TypeScript 自动更新** - 新键名立即可用，并带完整类型检查。

3. **立即使用**：
```typescript
t('category.newConstant')                        // "My New Text"
t('category.newFunction', { user: 'Steve', count: 5 })  // "Hello Steve, you have 5 items"
```

## 最佳实践

### 参数设计
```typescript
// ✅ 好的做法：使用描述性参数名
messageFrom: ({ sender }: { sender: string }) => `Message from ${sender}`,

// ✅ 好的做法：合理使用可选参数
at: ({ time, date }: { time: string; date?: string }) =>
    date ? `${time} on ${date}` : time,

// ✅ 好的做法：使用联合类型实现严格校验
greeting: ({ name, time }: { name: string; time: 'morning' | 'afternoon' | 'evening' }) =>
    `Good ${time}, ${name}!`,
```

### 复杂逻辑
```typescript
// ✅ 好的做法：将复杂逻辑放入翻译函数
statusMessage: ({ files, online, syncing }: {
    files: number;
    online: boolean;
    syncing: boolean;
}) => {
    if (!online) return 'Offline';
    if (syncing) return 'Syncing...';
    return files === 0 ? 'No files' : `${files} files ready`;
}
```

## 未来扩展

添加更多语言时：
1. 创建新的翻译文件（例如 `_spanish.ts`）
2. 更新类型以包含新语言
3. 添加语言切换逻辑
4. 所有现有类型安全保障均自动保留

本实现提供了坚实的基础，可在保持完善类型安全和开发体验的前提下持续扩展。
