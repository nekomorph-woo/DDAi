---
name: wok-codex-model
description: 配置 Codex subagent 的 model 字段。列出当前项目或用户目录 .codex/agents/ 下的 subagent，由用户指明修改范围（一个或多个），批量设置 model + model_reasoning_effort（默认 high）。Use when 用户要求配置 Codex agent 模型、改 Codex subagent 的 model、或提到 "wok-codex-model" / "codex model" / "Codex 模型配置"。
---

# Codex Agent Model 配置

修改**运行时项目**的 Codex subagent model 配置。目标：当前项目 `.codex/agents/` 或用户全局 `~/.codex/agents/` 下的 `*.toml`。

**DO NOT** 修改 wok 源 `plugins/wok-kit/skills/wok-starter/templates/codex-agents/`（wok 自带源配置，由 wok-starter 部署，不由本 skill 改）。

参考 [Codex subagents 文档](https://developers.openai.com/codex/subagents) 的 model 字段规范。

## Codex agent TOML 相关字段

| 字段 | 必需 | 说明 |
|------|------|------|
| `name` / `description` / `developer_instructions` | 是 | agent 身份与行为，本 skill 不动 |
| `model` | 否 | 模型名（如 `gpt-5.4`）；省略时继承父会话 |
| `model_reasoning_effort` | 否 | 推理强度：`low` / `medium` / `high` / `xhigh` |

## 执行流程

### 1. 定位并展示 .codex/agents/ 清单

检测以下两个目录，列出各自 `*.toml`：

| 目录 | 范围 |
|------|------|
| `<project>/.codex/agents/` | 当前项目级 Codex agent |
| `~/.codex/agents/` | 用户全局级 Codex agent |

对每个 toml 提取 `name` + `description` 首句，输出供用户查看：

```
当前项目 .codex/agents/:
  - code-reviewer        CLAUDE.md 合规审查 + bug 检测
  - wok-autopilot        管道自动执行引擎
  - ...

用户全局 ~/.codex/agents/:
  - <name>               <description 摘要>
  - ...

(目录不存在或为空 → 标注 "无")
```

两个目录都为空 → 报错退出，提示用户先运行 `/wok-starter` 部署 Codex agents。

### 2. 用户指明修改范围

**不使用选项**。直接询问用户：

> 请指明要修改 model 的 subagent（输入一个或多个 name，或"全部"）：

用户自由回复，例如：
- `code-reviewer` — 只改一个
- `code-reviewer comment-analyzer type-design-analyzer` — 改多个（空格分隔）
- `全部` / `all` — 改当前列出的所有

解析用户输入，匹配到对应 toml 文件（同时匹配项目级与全局级，重名时两端都改并提示）。匹配不到的 name → 提示并让用户重新指明。

### 3. 询问 Codex 模型名

使用 AskUserQuestion：

```json
{
  "question": "选定的 subagent 使用哪个 Codex 模型？",
  "header": "model",
  "options": [
    {"label": "gpt-5.4", "description": "审查/调试主力模型（Codex 文档示例 reviewer/debugger）"},
    {"label": "gpt-5.4-mini", "description": "轻量任务：exploration、docs research"},
    {"label": "gpt-5.3-codex-spark", "description": "实现/修复导向模型（Codex 文档示例 ui-fixer）"},
    {"label": "其他", "description": "自定义模型名（用户输入）"}
  ]
}
```

选"其他" → 询问自定义模型名字符串。

### 4. model_reasoning_effort

默认 `model_reasoning_effort = "high"`。

用户可指定 `low` / `medium` / `high` / `xhigh`；未指定时用 `high`。

### 5. 批量修改

对用户选定的每个 toml：

1. 解析 toml
2. 设置 `model = "<步骤 3 选定>"`
3. 设置 `model_reasoning_effort = "<步骤 4 选定>"`
4. 写回，**保留其他字段**（`name` / `description` / `developer_instructions` / `sandbox_mode` 等）不变

### 6. TOML 校验

每个修改的 toml 用 python3 tomllib 校验：

```bash
python3 -c "import tomllib; tomllib.load(open('<file>','rb'))"
```

校验失败 → 报错并列出问题文件。

### 7. 输出确认

```
✅ Codex subagent model 已配置

model: <选定> | model_reasoning_effort: <选定>

| Agent | 目录 | model | effort |
|-------|------|-------|--------|
| code-reviewer | <project>/.codex/agents/ | <model> | high |
| wok-autopilot | ~/.codex/agents/ | <model> | high |

所有修改的 toml 已通过 TOML 合法性校验。
```

## 检查清单

- [ ] 至少一个 `.codex/agents/` 目录存在且含 `*.toml`
- [ ] 已列出 toml 清单供用户查看
- [ ] 用户已指明修改范围（一个/多个/全部）
- [ ] 用户已确认模型名
- [ ] 选定范围内每个 toml 的 `model` + `model_reasoning_effort` 已设置
- [ ] 所有修改的 toml 通过 tomllib 校验
- [ ] 其他字段（name/description/developer_instructions/sandbox_mode）未被破坏
