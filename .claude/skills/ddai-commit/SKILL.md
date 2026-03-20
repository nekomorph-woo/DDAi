---
name: ddai-commit
description: 规范化 commit message 格式，提交后输出变更摘要。Use when 用户要求 commit、提交代码、或规范 commit message。
---

# DDAi Commit

规范化 commit message 格式，提交后输出简要变更信息。

## Commit Message 格式

```
<type>(<scope>): <description>
```

- **type**: 变更类型（必填）
- **scope**: 影响范围（必填，多处修改选主要 scope）
- **description**: 简要描述（单行，不支持 body/footer）

### Type 类型

| Type | 说明 |
|------|------|
| `feat` | 新功能 |
| `fix` | 修复 bug |
| `docs` | 文档变更 |
| `style` | 代码格式（不影响逻辑） |
| `refactor` | 重构 |
| `perf` | 性能优化 |
| `test` | 测试相关 |
| `chore` | 构建/工具/依赖 |
| `ci` | CI/CD 配置 |

## 执行流程

1. **分析变更**
   - 运行 `git diff --cached --stat` 查看暂存文件
   - 运行 `git diff --cached` 分析具体变更内容
   - 推断合适的 type 和 scope

2. **检测语言**（按优先级）
   1. 最近 5 条 commit message 语言
   2. CLAUDE.md 内容语言
   3. Claude Code 语言设置

3. **生成 commit message**
   - 使用检测到的语言编写 description
   - 格式: `<type>(<scope>): <description>`

4. **执行提交**
   - 运行 `git commit -m "<message>"`
   - 获取提交 ID

5. **输出变更摘要**

## 控制台输出格式

```
✅ 提交成功
提交 ID: <short_hash>

包含内容:
- <修改点1>
- <修改点2>
- ...

<git stat 输出>
```

### 示例

```
✅ 提交成功
提交 ID: 1ba2b60

包含内容:
- 新增 write-ddai-skill 项目级技能（5个文件）
- 优化 CLAUDE.md 标题
- 更新 write-a-skill 插件（添加示例引用和版本号检查项）

5 files changed, 120 insertions(+), 30 deletions(-)
```

## Scope 推断规则

| 变更路径 | Scope 示例 |
|----------|-----------|
| `src/auth/*` | `auth` |
| `src/api/user.ts` | `api` |
| `tests/*` | `test` |
| `docs/*` | `docs` |
| `package.json`, `*.lock` | `deps` |
| `.github/workflows/*` | `ci` |
| 根目录配置文件 | `config` |
| 无法确定时 | 使用项目名或 `core` |

## Type 推断规则

| 变更特征 | Type |
|----------|------|
| 新增文件/函数/组件 | `feat` |
| 修复逻辑错误/bug | `fix` |
| 仅修改注释/文档 | `docs` |
| 代码格式调整（无逻辑变更） | `style` |
| 重构代码结构（无功能变更） | `refactor` |
| 性能相关优化 | `perf` |
| 测试文件变更 | `test` |
| 依赖/构建配置变更 | `chore` |
| CI/CD 配置变更 | `ci` |
