# 完整插件示例

以下是一个包含所有组件的 DDAi 插件示例：

```
plugins/api-client/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   └── api-client.md
└── skills/
    └── api-client/
        ├── SKILL.md
        ├── reference/
        │   ├── authentication.md
        │   └── error-handling.md
        ├── examples/
        │   └── basic-usage.md
        └── scripts/
            └── validate-response.js
```

**plugin.json 内容**：

```json
{
  "name": "api-client",
  "version": "0.1.0"
}
```

**commands/api-client.md 内容**：

```md
---
name: api-client
description: 调用 REST API、处理认证和错误响应。Use when 需要调用外部 API、处理 HTTP 请求，或用户提到 API、REST、HTTP、认证。
---

执行 [api-client 技能](../skills/api-client/SKILL.md) 的完整流程。
```

**skills/api-client/SKILL.md 内容**：

```md
---
name: api-client
description: 调用 REST API、处理认证和错误响应。Use when 需要调用外部 API、处理 HTTP 请求，或用户提到 API、REST、HTTP、认证。
---

# API 客户端

## 快速开始

使用 `scripts/validate-response.js` 验证响应格式。

## 工作流程

1. 确定认证方式（详见 [reference/authentication.md](reference/authentication.md)）
2. 构建请求
3. 发送请求
4. 处理响应或错误（详见 [reference/error-handling.md](reference/error-handling.md)）

## 检查清单

- [ ] 确认 API 端点
- [ ] 配置认证信息
- [ ] 设置请求超时
- [ ] 处理错误响应
```
