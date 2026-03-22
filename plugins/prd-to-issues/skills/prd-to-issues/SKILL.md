---
name: prd-to-issues
description: 使用垂直切片（tracer bullet）将 PRD 拆分为可独立认领的 issue。Use when 用户要求将 PRD 转为 issue、创建实现任务、或拆分 PRD 为工作项。
---

# PRD 转 Issue

使用垂直切片（tracer bullet）将 PRD 拆分为可独立认领的 issue。

## 流程

### 1. 定位 PRD

向用户询问 PRD issue 编号或 URL。

若 PRD 不在当前上下文中，根据平台判断使用对应 CLI 获取内容（含评论）。

### 2. 探索代码库（可选）

若尚未了解代码库，探索以理解当前状态。

### 3. 起草垂直切片

将 PRD 拆分为 **tracer bullet** issue。每个 issue 是贯穿所有集成层的薄垂直切片，而非单一层的水平切片。

切片分为两种类型：
- **HITL**（Human In The Loop）：需要人工交互，如架构决策或设计评审
- **AFK**（Away From Keyboard）：可独立完成并合并，无需人工交互

优先选择 AFK 切片。

<vertical-slice-rules>
- 每个切片提供窄但完整的端到端路径（schema、API、UI、测试）
- 完成的切片可独立演示或验证
- 多个薄切片优于少数厚切片
</vertical-slice-rules>

### 4. 与用户确认

以编号列表展示拆分方案。每个切片包含：

- **标题**：简短描述名称
- **类型**：HITL / AFK
- **阻塞依赖**：哪些切片必须先完成
- **覆盖用户故事**：对应 PRD 中的哪些用户故事

向用户询问：

- 粒度是否合适？（过粗/过细）
- 依赖关系是否正确？
- 是否需要合并或进一步拆分？
- HITL/AFK 标记是否正确？

迭代直至用户确认。

### 5. 创建 Issue

对每个确认的切片，根据平台判断使用对应 CLI 创建 issue。按依赖顺序创建（阻塞项优先），以便在"阻塞依赖"字段引用真实 issue 编号。

<issue-template>
## 父 PRD

#<prd-issue-number>

## 构建内容

垂直切片的简要描述。描述端到端行为，而非逐层实现。引用父 PRD 具体章节而非复制内容。

## 验收标准

- [ ] 标准 1
- [ ] 标准 2
- [ ] 标准 3

## 阻塞依赖

- 阻塞于 #<issue-number>（若有）

若无阻塞依赖，填写"无 - 可立即开始"。

## 覆盖用户故事

按编号引用父 PRD：

- 用户故事 3
- 用户故事 7

</issue-template>

**DO NOT** 关闭或修改父 PRD issue。

## 平台判断

通过 `git remote get-url origin` 判断代码托管平台，使用对应 CLI：

| 平台 | 判断条件 | CLI |
|------|----------|-----|
| GitHub | URL 包含 `github.com` | `gh` |
| GitLab | URL 包含 `gitlab.com` 或私有 GitLab 域名 | `glab` |
