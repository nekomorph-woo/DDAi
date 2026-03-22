# 基础插件示例

以下是一个最小化的 DDAi 插件示例：

```
plugins/format-json/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   └── format-json.md
└── skills/
    └── format-json/
        └── SKILL.md
```

**plugin.json 内容**：

```json
{
  "name": "format-json",
  "version": "0.1.0"
}
```

**commands/format-json.md 内容**：

```md
---
name: format-json
description: 格式化、验证和转换 JSON 数据。Use when 处理 JSON 文件，或用户提到 JSON 格式化、验证、转换。
---

执行 [format-json 技能](../skills/format-json/SKILL.md) 的完整流程。
```

**skills/format-json/SKILL.md 内容**：

```md
---
name: format-json
description: 格式化、验证和转换 JSON 数据。Use when 处理 JSON 文件，或用户提到 JSON 格式化、验证、转换。
---

# JSON 格式化

## 快速开始

1. 读取目标 JSON 文件
2. 验证 JSON 语法
3. 按配置格式化输出

## 工作流程

- [ ] 检查文件是否存在
- [ ] 验证 JSON 语法有效性
- [ ] 应用格式化规则
- [ ] 输出结果
```
