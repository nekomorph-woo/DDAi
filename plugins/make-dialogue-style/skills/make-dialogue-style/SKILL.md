---
name: make-dialogue-style
description: 管理项目对话风格配置，初始化或自定义 .claude/rules/dialogue-style.md，辅助编写其他 rules 文件。Use when 用户要求配置对话风格、设置输出规范、创建 rules 文件，或提到 "dialogue-style" / "对话风格" / "rules"。
---

# 对话风格配置

管理项目的 `.claude/rules/dialogue-style.md` 配置文件。

## 流程

### 1. 检查文件状态

读取项目根目录 `.claude/rules/dialogue-style.md`。

### 2. 处理结果

**文件不存在**：
- 拷贝 [reference/dialogue-style.md](reference/dialogue-style.md) 到 `.claude/rules/dialogue-style.md`
- 输出：`✅ 已创建 .claude/rules/dialogue-style.md`

**文件已存在**：
- 询问用户意图：
  - 查看当前配置
  - 修改特定章节
  - 添加新规则
  - 重置为默认配置

### 3. 创建其他 Rules

用户需要创建其他 rules 文件时：
- 询问 rules 名称和目标
- 基于项目上下文编写专业规则
- 保存到 `.claude/rules/<name>.md`

## Rules 编写原则

| 原则 | 说明 |
|------|------|
| **命令式** | 使用祈使句，直接指示动作 |
| **第三人称** | 不使用 "I will..." / "我会..." |
| **具体触发** | 明确 "Use when [条件]" |
| **精简示例** | 提供正确/错误对比 |

## 默认配置内容

详见 [reference/dialogue-style.md](reference/dialogue-style.md)。

包含：
- 输出规范（变更摘要、错误处理、进度反馈）
- 对话美学（可视化优先、方案先行、Emoji 增强）
- 安全规范（敏感信息检测）
- 编码规范（兼容代码原则）
- ASCII/Emoji 速查表
