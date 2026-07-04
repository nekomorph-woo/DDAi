---
name: wok-starter
description: 初始化项目的 wok 环境：部署 rules 规则文件（Claude Code / Cursor / Codex 三端）、Codex agents、配置 .gitignore 忽略项。Use when 用户要求初始化 wok、首次使用 wok、或提到 "wok-starter" / "初始化" / "wok 初始化"。
---

# wok 初始化

初始化项目的 wok 环境，按用户选定的目标端部署 rules、Codex agents，并配置 gitignore。三端部署规范详见 [wok-refine-rule 的 deploy-targets.md](../wok-refine-rule/reference/deploy-targets.md)。

## 执行流程

### 1. 确定目标端

按 [deploy-targets.md](../wok-refine-rule/reference/deploy-targets.md) 步骤 0 执行：

1. 检测项目根已有端目录（`.claude/` / `.cursor/` / `.codex/` / `AGENTS.md`），已存在端作默认
2. AskUserQuestion 多选目标端（Claude Code / Cursor / Codex），用户未指定时**默认仅 Claude Code**（向后兼容老项目）

### 2. 部署 Rules

调用 `/wok-refine-rule` 初始化流程，传入步骤 1 确定的目标端。wok-refine-rule 按端格式部署 reference 模板：

| 端 | 目录 | 格式 |
|----|------|------|
| Claude Code | `.claude/rules/*.md` | 原样（保留 YAML 头） |
| Cursor | `.cursor/rules/*.mdc` | YAML 头 → frontmatter |
| Codex | `.codex/rules/*.md` + 根 `AGENTS.md` | 剥 YAML 头 + `@` 引用聚合 |

同名文件存在时跳过（保留用户自定义）。

### 3. 部署 Codex Agents（仅 Codex 端）

若步骤 1 选定 Codex 端，部署 wok 自带的 Codex agents：

1. 源：本 skill 的 [templates/codex-agents/](templates/codex-agents/) `*.toml`（6 个预清洗 agent）
2. 目标：项目根 `.codex/agents/*.toml`
3. 同名文件存在时跳过

**agent 清单**：`code-reviewer` / `comment-analyzer` / `pr-test-analyzer` / `silent-failure-hunter` / `type-design-analyzer` / `wok-autopilot`。

> Codex 端用户需自行安装 wok 管道 skill（autopilot 依赖 `wok-implement` / `wok-code-review`，用户在 Codex 预装后可用）。

未选 Codex 端时跳过此步骤。

### 4. 配置 .gitignore

检测当前是否为 git 仓库（`git rev-parse --git-dir`）。

**是 git 仓库**：检查 `.gitignore` 中是否已包含以下条目，缺失则追加：

```
.wok-plans/
.wok-grill/
.wok-handoff/
```

追加后按原格式保持 `.gitignore` 结构（若文件存在 `\n` 结尾则保持，无则不加多余空行）。

**非 git 仓库**：跳过此步骤。

### 5. 输出结果

```
✅ wok 初始化完成

目标端：Claude Code + Codex

Rules:
| 端 | 文件 | 状态 |
|---|---|---|
| Claude Code | .claude/rules/coding-philosophy.md | ✅ 已创建 |
| Claude Code | .claude/rules/security.md | ⏭️ 已存在（跳过） |
| Codex | .codex/rules/coding-philosophy.md | ✅ 已创建 |
| Codex | AGENTS.md（入口） | ✅ 已创建 |

Codex Agents（仅 Codex 端）:
- ✅ .codex/agents/code-reviewer.toml
- ✅ .codex/agents/comment-analyzer.toml
- ✅ .codex/agents/pr-test-analyzer.toml
- ✅ .codex/agents/silent-failure-hunter.toml
- ✅ .codex/agents/type-design-analyzer.toml
- ✅ .codex/agents/wok-autopilot.toml

.gitignore:
- ✅ 已添加 .wok-plans/
- ✅ 已添加 .wok-grill/
- ✅ 已添加 .wok-handoff/
```

## 检查清单

- [ ] 目标端已确定（检测 + 询问）
- [ ] rules 已部署到各选定端目录（每端至少 1 个规则文件）
- [ ] Codex 端：`.codex/agents/` 下 6 个 toml 已部署
- [ ] Codex 端：根 `AGENTS.md` 入口已生成
- [ ] `.gitignore` 已包含 `.wok-plans/`、`.wok-grill/`、`.wok-handoff/`（git 仓库时）
