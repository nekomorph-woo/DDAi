# Skill 语气与措辞规范

基于 `/Volumes/Under_M2/a056cw/skills` 目录下优秀技能的逆向分析。

---

## 语气要求

| 要求 | 说明 |
|------|------|
| **命令式** | 使用祈使句，直接指示动作 |
| **第三人称** | 描述技能能力，不用 "I will..." / "我会..." |
| **直接简洁** | 不使用 "Please try to..." / "你可以尝试..." |
| **克制专业** | 避免华丽辞藻，用词精准无歧义 |

---

## 正确 vs 错误示例

| 场景 | 错误 | 正确 |
|------|------|------|
| 指示动作 | "You might want to create an issue..." | "Create a GitHub issue..." |
| 描述能力 | "I will help you write tests..." | "Write tests that verify behavior..." |
| 询问用户 | "Could you please tell me..." | "Ask the user: What problem needs solving?" |
| 步骤说明 | "It would be good to check..." | "Check the following before proceeding:" |

---

## 措辞原则

### 1. 精准无歧义

- 一个词只表达一个含义
- 避免模糊词汇：`可能`、`也许`、`大概`、`一些`
- 使用具体数字代替模糊量词

```
错误: Write some tests
正确: Write one test per behavior
```

### 2. 动词优先

- 句子以动词开头
- 避免名词化表达

```
错误: The creation of the file is required
正确: Create the file
```

### 3. 否定指令明确

- 告诉做什么，而非不做什么
- 必须说"不"时，使用 `DO NOT` 强调

```
错误: Don't forget to run tests
正确: Run tests after each change

错误: Avoid horizontal slices
正确: DO NOT write all tests first, then all implementation
```

### 4. 条件与后果清晰

```
错误: If needed, add more tests
正确: If the module has edge cases, add tests for each case
```

---

## 格式配合语气

| 元素 | 格式 | 作用 |
|------|------|------|
| 关键概念 | `**粗体**` | 强调核心术语 |
| 必须遵守 | `DO NOT` / `ALWAYS` | 表达强制约束 |
| 代码/命令 | 代码块或行内代码 | 区分指令与描述 |
| 检查项 | `- [ ]` checkbox | 可执行的验证点 |

---

## 反模式

| 反模式 | 问题 | 修正 |
|--------|------|------|
| 委婉语气 | "It might be helpful to..." | 直接说 "Do X" |
| 第一人称 | "I suggest..." / "我会建议..." | 改为命令式 |
| 过度解释 | 冗长的原因说明 | 只说做什么，必要时简述原因 |
| 模糊触发 | "Use when appropriate" | "Use when [具体条件]" |
| 口语化 | "basically" / "just" | 删除填充词 |

---

## 版本规范

所有插件起始版本为 `0.1.0`。
