# 编码规范

## 1. 兼容代码原则
- 直接修改旧实现，移除废弃代码，不保留向后兼容逻辑
- 移除 `_old`、`_legacy` 等遗留命名标记
- **Rationale**: AI Coding 快速迭代，兼容代码增加维护成本且大多数情况下不必要

## 2. 提交控制
- 完成编码后等待用户明确的 commit/push 指令再执行
- **Rationale**: 用户可能需要审阅变更、调整提交内容或拆分提交

## 3. 脚本语言选择

| 语言 | 适用场景 | 约束 |
|------|----------|------|
| **Bash** | 文件/目录操作、简单命令组合 | 仅 Unix 系统 |
| **Python** | 数据处理、API调用、中等复杂逻辑 | 仅使用标准库，不引入三方依赖 |
| **TypeScript** | 复杂业务逻辑、与项目共享类型 | 必须提供 `npx ts-node` 运行方式或预编译 JS |

**优先级**：Bash > Python > TypeScript

**Python 标准库覆盖**：

| 功能 | 标准库 | 是否需要三方库 |
|------|--------|----------------|
| JSON/CSV/XML | `json`, `csv`, `xml.etree` | ❌ |
| HTTP 请求 | `urllib.request` | ⚠️ 可用但繁琐 |
| Excel 解析 | - | ✅ 需要 `openpyxl` |
| 文件系统 | `pathlib`, `os`, `shutil` | ❌ |

如需三方库，在 SKILL.md 中明确声明依赖。

## 4. 任务执行触发时机

当以下时机出现时，主动询问用户是否进入【任务规划和执行】：

- 用户完成决策或方案选择
- 用户完成 issue 创建
- 用户完成问题/异常分析，得出根因
- 用户基于 TDD 方式完成开发计划分析
- 用户完成 PRD 或架构设计
- 用户完成重构计划决策
- 用户主动要求执行编程任务

## 5. 任务规划和执行

### 5.1 任务规划

使用 EnterPlanMode 进入计划模式制定实现计划，通过 sub-agent 和 Read/Glob/Grep 工具探索代码库，将计划写入系统指定的计划文件，调用 ExitPlanMode 提交用户审阅。

> 计划内容至少包含：任务拆分与阶段划分、关键文件和修改点、验证标准

### 5.2 执行跟踪

用户批准计划后，使用 TaskCreate 创建任务列表：
- 为每个任务设置简明的 subject 和具体的 description
- 使用 addBlocks/addBlockedBy 设置任务依赖
- 无依赖的任务可并行执行（最多 2~3 个）
- 工作流：开始前 TaskUpdate → in_progress，完成后立即 → completed，TaskList 查看进度
