# 模块设计输出格式

> **📝 文风要求**（完整规范见 `skills/_shared/doc-writing-style.md`）：
> 1. 写完整句子，不写电报体——占位符都按例句的完整句式填充，不照抄例句文字
> 2. 术语首次出现就通俗解释（`req:` 前缀、模块边界、接口契约、意图分离等见下方术语说明）
> 3. section 间加 1 句过渡；表格前加 1-2 句说明"这个表格讲什么"

## 目录结构

```
.wok-plans/<system-name>/                ← 无 roadmap 时（下文以 <phase-dir> 统称）
.wok-plans/<system-name>/p<n>-<phase>/  ← 有 roadmap 时
<phase-dir>/
├── _define.md                    ← 上游产出（wok-define）
└── modules/
    ├── _registry.md              ← 模块注册表 + 持久架构决策
    ├── _shared/                  ← 公共产物（交叉分析提取）
    │   ├── models.md
    │   ├── utils.md
    │   ├── constants.md
    │   └── errors.md
    └── <module-name>/
        ├── design.md             ← 接口契约（intent: reference）
        └── decisions.md          ← 设计决策（intent: explanation）
```

## _registry.md

```markdown
---
status: draft
intent: reference
scope: global
depends: [req:<feature-name>]
changed: 初始版本
---

> **模块数**：N 个
> **依赖方向**：<概述>
> **阻塞**：<阻塞项>

## 模块概览

| 模块 | 职责 | 依赖 | 状态 |
|------|------|------|------|

## 依赖图

（ASCII 有向图，箭头表示依赖方向）

## 持久架构决策

将上游设计锚点翻译为具体架构决策：

| 设计锚点 | 架构决策 | 认领模块 | 兼容性 |
|----------|----------|----------|--------|
| [EFFECT] 认证必须在一个请求内完成 | 采用 JWT + httpOnly Cookie | auth-core, api-gateway | 与现有 session 中间件不兼容，需迁移 |
| [EXCLUSION] 不引入第三方认证服务 | — | — (排除约束) | — |

- [EXCLUSION] 锚点无认领模块，由 wok-design-review 脚本扫描违规

```

## design.md（每个模块）

```markdown
---
status: draft
intent: reference
scope: affected-modules
depends: [req:<feature-name>]
changed: 初始版本
---

> **做什么**：<完整句子，如"这个模块负责用户认证和授权管理，对外暴露登录、登出、令牌刷新三个接口">
> **接口数**：<N> 个
> **阻塞**：<阻塞项，无则写"无">

## 接口契约

<details>
<summary>【详细接口】FunctionName — 用一句话写清这个函数做什么（如"校验用户凭证并签发访问令牌"）</summary>

### 参数
| 字段 | 类型 | 必填 | 说明 |
|------|------|:----:|------|

### 返回值
| 字段 | 类型 | 说明 |
|------|------|------|

### 异常
| 场景 | 处理 |
|------|------|
</details>

## 实现约束

- 约束 1
- 约束 2
```

## decisions.md（每个模块）

```markdown
---
status: draft
intent: explanation
scope: affected-modules
depends: [req:<feature-name>]
changed: 初始版本
---

> **关键决策**：N 条

## 锚点认领

逐条声明本模块对上游设计锚点的认领关系：

> - [EFFECT] <锚点内容> → 本模块主责
> - [SECURITY] <锚点内容> → 本模块主责
> - [EFFECT] <锚点内容> → 依赖 <其他模块名> 模块
> - [EXCLUSION] <锚点内容> → 全局约束，无认领模块

## 决策

### [DECISION] <决策标题>

**选择**：<方案>
**否决**：<被否决的方案>
**理由**：<为什么>
**影响**：<影响范围>
```

## 意图分离原则

| 文件 | 意图 | 读者目的 | 什么放这里 |
|------|------|----------|------------|
| design.md | reference | "接口怎么定义？" | 签名、参数、返回值、异常、约束 |
| decisions.md | explanation | "为什么这样设计？" | 方案选择、取舍理由、设计锚点响应 |

**DO NOT** 在 design.md 中写"为什么选择了 X 而不是 Y"。那属于 decisions.md。
**DO NOT** 在 decisions.md 中写接口签名。那属于 design.md。
**DO NOT** 使用缩写标记（如 `D1`、`D2`、`O1`），必须使用完整 `### [DECISION]` / `### [OPEN]` / `- [ACTION]` 格式

## 术语说明

- **`req:` 前缀**：frontmatter `depends` 字段里的 `req:<feature-name>` 表示依赖的需求文档（requirement），即上游 `_define.md` 所属的功能名
- **模块边界**：模块的职责划分范围——一个模块只做一组紧密相关的事，边界清晰才能独立设计和修改
- **接口契约**：模块对外的"使用说明书"——函数签名、参数、返回值、异常；调用方据此使用模块，无需关心内部实现
- **意图分离**（design.md vs decisions.md）：design.md 回答"接口怎么定义"（reference，供调用方查阅）；decisions.md 回答"为什么这样设计"（explanation，供后续追溯权衡理由）
- **`_shared/`**：跨模块共享的公共产物（如 models.md 数据模型、errors.md 错误码），避免在多个模块里重复定义
