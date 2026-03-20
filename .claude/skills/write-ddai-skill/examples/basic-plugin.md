# 基础插件示例

以下是一个最小化的 DDAi 插件结构：

```
plugins/my-plugin/
├── SKILL.md
├── reference/
│   └── .gitkeep
├── examples/
│   └── .gitkeep
└── scripts/
    └── .gitkeep
```

**SKILL.md 内容**：

```md
---
name: my-plugin
description: 执行特定任务的简短描述。Use when [具体触发条件]。
---

# 插件名称

## 快速开始

提供最简可运行示例。

## 工作流程

复杂任务分步执行并检查。

## 检查清单

- [ ] 步骤 1
- [ ] 步骤 2
```

**marketplace.json 注册**：

```json
{
  "name": "my-plugin",
  "path": "plugins/my-plugin",
  "description": "插件描述",
  "version": "0.1.0"
}
```
