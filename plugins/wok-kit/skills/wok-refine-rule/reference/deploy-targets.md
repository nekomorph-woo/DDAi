# 三端 Rules 部署规范

> 本文件是 wok-kit 所有 rules 注入型 skill（wok-refine-rule / wok-tech-stack / wok-ontology / wok-ui-design / wok-starter）的**共享部署规范**。各 skill 在初始化时按本规范决定 rules 文件落到哪个目录、用什么格式。

---

## 适用范围

| skill | 自管理文件 |
|-------|-----------|
| wok-refine-rule | 通用 rules（`coding-philosophy.md`、`dialogue-style.md`、`security.md` 等 7 个） |
| wok-tech-stack | `stack-*.md`（core/desktop/mobile/web/monorepo） |
| wok-ontology | `ontology-*.md`（core/define/design/implement） |
| wok-ui-design | `design-tokens.md` |
| wok-starter | 部署编排（调用 wok-refine-rule + 部署 Codex agents） |

---

## 三端路径对照表

| 类型 | Claude Code | Cursor | Codex |
|------|-------------|--------|-------|
| rules 目录 | `.claude/rules/*.md` | `.cursor/rules/*.mdc` | `.codex/rules/*.md` |
| rules 文件格式 | 原样 `.md`（保留 YAML 头） | `.mdc`（从 YAML 头生成 frontmatter + 正文） | `.md`（**剥除** YAML 头后原样） |
| rules 入口 | 自动加载 | 自动加载（基于 frontmatter） | 项目根 `AGENTS.md` 用 `@` 引用聚合 |
| 项目规则总入口 | `CLAUDE.md` | `.cursor/rules/` | `AGENTS.md` |

---

## 部署规则

### Claude Code 端

1. 目标：`.claude/rules/<file>.md`
2. 从 `reference/<file>.md` **原样拷贝**（保留 YAML 头，Claude Code 加载机制忽略未知 YAML，正文照常呈现）
3. 同名文件已存在 → 跳过（保留用户自定义）

### Cursor 端

1. 目标：`.cursor/rules/<file>.mdc`
2. 读 `reference/<file>.md`，提取顶部 YAML 头生成 Cursor frontmatter：

   ```yaml
   ---
   description: <cursor-description>
   globs: <cursor-globs>       # 留空则整行省略
   alwaysApply: <always-apply> # 默认 true
   ---
   ```

3. 正文 = reference 正文（去掉 YAML 头）写入 frontmatter 之后
4. reference 缺失 YAML 头 → fallback 用 H1 标题作 description，`alwaysApply: true`，并打 warning
5. 同名 `.mdc` 已存在 → 跳过

### Codex 端

1. 目标：`.codex/rules/<file>.md`
2. 从 `reference/<file>.md` 拷贝，**剥除顶部 YAML 头**（避免 YAML 残留拼接进 Codex 上下文）
3. 同名文件已存在 → 跳过
4. **额外生成项目根 `AGENTS.md`**（Codex CLI 只读根 `AGENTS.md`，`.codex/rules/` 本身不自动扫描）—— 用 `@.codex/rules/<file>.md` 引用聚合所有规则文件作入口。详见 [AGENTS.md.template](AGENTS.md.template)

---

## reference 模板 YAML 头规范

每个 `reference/*.md` 顶部加 frontmatter，存放三端共享元数据：

```markdown
---
wok:
  cursor-description: <一句话描述，显示在 Cursor Rules 面板>
  cursor-globs: ""           # 留空 = alwaysApply；填 glob 则按文件触发
  always-apply: true         # Cursor frontmatter 的 alwaysApply
---

# 原标题
...（正文不变）
```

**字段说明**：

| 字段 | 作用 | 缺失时 |
|------|------|--------|
| `cursor-description` | Cursor `.mdc` 的 description 字段 | fallback 用 H1 标题 |
| `cursor-globs` | Cursor 触发文件匹配模式 | 留空，配合 always-apply |
| `always-apply` | 是否无条件加载 | 默认 true |

**为什么用 YAML 而非 HTML 注释**：Cursor 解析不了 HTML 注释里的元数据；YAML 是 Cursor `.mdc` 原生格式。Claude Code 忽略未知 YAML 无副作用；Codex 端拷贝时剥除。

---

## 步骤 0：确定目标端

所有 rules 注入型 skill 在初始化前，先执行目标端确定：

### 0.1 自动检测（作默认值）

扫描项目根，已存在的端默认勾选：

| 检测项 | 推断 |
|--------|------|
| `.claude/rules/*.md` 或 `.claude/` 目录 | Claude Code |
| `.cursor/rules/*.mdc` 或 `.cursor/` 目录 | Cursor |
| `.codex/` 目录或根 `AGENTS.md` | Codex |

### 0.2 询问用户

使用 AskUserQuestion 多选目标端。已检测端默认勾选，未检测端默认不勾选。用户未指定时**默认仅 Claude Code**（向后兼容老项目）。

### 0.3 各 skill 独立判断

wok-tech-stack / wok-ontology / wok-ui-design 可能在 wok-starter 之后单独调用，各自执行 0.1 + 0.2 独立判断目标端（v1 不持久化选择，每次询问）。

---

## 已知 Claude Code 耦合点（Known Limitation）

以下内容在 reference 模板里是 Claude Code 专属引用，三端部署时**原样拷贝**（无害但不会在 Cursor/Codex 触发对应机制）。v1 不做内容差异化，v2 可迭代。

| 耦合点 | 来源文件 | 在 Cursor/Codex 的表现 |
|--------|---------|----------------------|
| `/compact` slash command、`This is a good point to compact.` 短语 | compact-guide.md | 无害文本，不触发 prompt suggestion |
| `AskUserQuestion` / `EnterPlanMode` / `TaskCreate` 工具名 | coding-conventions.md / coding-philosophy.md | 概念存在，各端有等价物（Cursor/Codex 的 ask-user/plan） |
| `/wok-idea` 等 wok slash commands | pipeline-guide.md | 无害文本；wok 管道本身是 Claude Code plugin，需用户在 Codex 预装对应 skill |
| `CLAUDE.md` 引用 | 多处 | Codex 端等价物是 `AGENTS.md`；审查类 agent 已做术语替换，rules 模板暂保留原文 |

---

## 多端 rules 的源真相约定

- `reference/*.md` 是**唯一源真相**，三端是镜像
- 改进某端 rules 后，同步回 `reference/` 再重新初始化其他端
- 三端各自同名文件存在时跳过；强制覆盖需用户确认（"重置某端"子流程）
