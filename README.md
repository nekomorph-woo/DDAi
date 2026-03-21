# DDAi - AI 辅助开发的技能市场

**DDAi**（DD's AI Assistant）是一套为 Claude Code 设计的技能插件集合，旨在将 AI 从"代码生成工具"升级为"全流程开发伙伴"。

## 核心理念

### 问题

AI 编程助手擅长生成代码片段，但在以下方面存在短板：

- **缺乏上下文**：不理解项目历史、架构决策、团队约定
- **流程断裂**：需求 → 设计 → 开发 → 测试 各环节孤立
- **随意性强**：输出质量高度依赖 prompt 质量，缺乏一致性

### 解决方案

DDAi 通过**技能插件化**解决上述问题：

```
┌─────────────────────────────────────────────────────────┐
│                    Claude Code                          │
├─────────────────────────────────────────────────────────┤
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐    │
│  │ 需求    │  │ 设计    │  │ 开发    │  │ 质量    │    │
│  │ Skills  │→ │ Skills  │→ │ Skills  │→ │ Skills  │    │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘    │
│       ↓            ↓            ↓            ↓         │
│  ┌─────────────────────────────────────────────────┐   │
│  │              统一的对话风格 & 规范               │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

### 设计原则

| 原则 | 说明 |
|------|------|
| **渐进式信息** | SKILL.md 精简，reference/ 深入，examples/ 示范 |
| **确定性优先** | 可脚本化的操作用脚本，避免重复生成 |
| **流程衔接** | 插件间可组合，形成完整工作流 |
| **规范统一** | 命令式语气、第三人称、精准措辞 |

---

## 技能概览

按软件开发生命周期组织。标记 🤖 的技能使用 **Sub-Agent** 并行处理或深度探索。

### Sub-Agent 使用说明

| 模式 | 技能 | 为什么使用 Sub-Agent |
|------|------|----------------------|
| **并行生成** | design-an-interface | 同时产出多个差异显著的设计方案，避免单一视角局限 |
| **代码库探索** | write-a-prd | 验证用户断言、理解现有架构，避免 PRD 与实际脱节 |
| **代码库探索** | improve-codebase-architecture | 自然探索发现摩擦点，而非按固定清单检查 |
| **代码库探索** | triage-issue | 深入调查定位问题根因，而非表面猜测 |

### 需求阶段

| 技能 | 目标 | 使用场景 |
|------|------|----------|
| **office-hours** | 需求价值诊断 | 评估想法是否值得做、在写代码前深度思考产品方向 |
| **write-a-prd** 🤖 | 创建产品需求文档 | 规划新功能、编写 PRD、创建需求文档 |

### 设计阶段

| 技能 | 目标 | 使用场景 |
|------|------|----------|
| **prd-to-plan** | PRD 转实现计划 | 将需求文档拆分为多阶段实施计划 |
| **prd-to-issues** | PRD 转可认领 issue | 将需求拆分为独立工作项，分配给团队成员 |
| **design-an-interface** 🤖 | 接口方案设计 | 探索 API 设计选项、对比不同模块形态 |
| **grill-me** | 计划压力测试 | 审视计划漏洞、系统性追问直至共识 |
| **ubiquitous-language** | 统一领域语言 | 消除术语歧义、构建团队词汇表 |
| **improve-codebase-architecture** 🤖 | 架构改进分析 | 发现重构机会、提升代码可测试性 |
| **request-refactor-plan** | 重构计划制定 | 将重构拆分为安全增量步骤 |

### 开发阶段

| 技能 | 目标 | 使用场景 |
|------|------|----------|
| **tdd** | 测试驱动开发 | 使用 RED-GREEN-REFACTOR 循环开发功能 |
| **quick-commit** | 规范化提交 | 生成标准 commit message，关联 issue |

### 质量保证

| 技能 | 目标 | 使用场景 |
|------|------|----------|
| **triage-issue** 🤖 | 问题根因分析 | 报告 bug、创建带修复计划的 issue |

### 工具 & 辅助

| 技能 | 目标 | 使用场景 |
|------|------|----------|
| **write-a-skill** | 创建新技能 | 开发个人技能或 DDAi 插件 |
| **edit-article** | 文章编辑优化 | 重组章节、精简措辞、优化文档结构 |
| **make-dialogue-style** | 对话风格配置 | 设置项目输出规范、创建 rules 文件 |

---

## 组合工作流

### 工作流 1：新功能完整流程

```
用户想法
    │
    ▼
┌─────────────┐
│ office-hours│  验证需求价值
└──────┬──────┘
       │ 值得做
       ▼
┌─────────────┐
│write-a-prd  │  创建需求文档
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ prd-to-plan │  拆分实施计划
└──────┬──────┘
       │
       ▼
┌──────────────────┐
│design-an-interface│  设计接口方案
└──────┬───────────┘
       │
       ▼
┌─────────────┐
│   grill-me  │  压力测试计划
└──────┬──────┘
       │ 通过
       ▼
┌─────────────┐
│prd-to-issues│  创建可认领 issue
└──────┬──────┘
       │
       ▼
┌─────────────┐
│     tdd     │  测试驱动开发
└──────┬──────┘
       │
       ▼
┌─────────────┐
│quick-commit │  规范化提交
└─────────────┘
```

### 工作流 2：Bug 修复流程

```
Bug 报告
    │
    ▼
┌─────────────┐
│triage-issue │  分析根因，创建修复计划
└──────┬──────┘
       │
       ▼
┌─────────────┐
│     tdd     │  TDD 方式修复
└──────┬──────┘
       │
       ▼
┌─────────────┐
│quick-commit │  提交并关联 issue
└─────────────┘
       │
       ▼
  Issue 自动关闭
```

### 工作流 3：架构改进流程

```
代码腐化信号
    │
    ▼
┌───────────────────────────┐
│improve-codebase-architecture│  发现改进机会
└───────────┬───────────────┘
            │
            ▼
┌────────────────────┐
│request-refactor-plan│  制定重构计划
└─────────┬──────────┘
          │
          ▼
┌─────────────┐
│   grill-me  │  验证重构方案
└──────┬──────┘
       │
       ▼
┌─────────────┐
│prd-to-issues│  拆分为安全增量 issue
└──────┬──────┘
       │
       ▼
   逐步重构
```

### 工作流 4：快速迭代（跳过设计）

```
明确的小需求
    │
    ▼
┌─────────────┐
│     tdd     │  直接 TDD 开发
└──────┬──────┘
       │
       ▼
┌─────────────┐
│quick-commit │  快速提交
└─────────────┘
```

---

## 快速开始

### 安装 Marketplace

在 Claude Code 中添加 DDAi marketplace：

```
/plugin marketplace add nekomorph-woo/DDAi
```

### 安装插件

安装单个插件：

```
/plugin install tdd@ddai
/plugin install quick-commit@ddai
```

安装所有插件（推荐）：

```
/plugin install write-a-prd@ddai
/plugin install office-hours@ddai
/plugin install prd-to-plan@ddai
/plugin install prd-to-issues@ddai
/plugin install design-an-interface@ddai
/plugin install grill-me@ddai
/plugin install ubiquitous-language@ddai
/plugin install improve-codebase-architecture@ddai
/plugin install request-refactor-plan@ddai
/plugin install tdd@ddai
/plugin install quick-commit@ddai
/plugin install triage-issue@ddai
/plugin install write-a-skill@ddai
/plugin install edit-article@ddai
/plugin install make-dialogue-style@ddai
```

### 更新 Marketplace

获取最新插件更新：

```
/plugin marketplace update ddai
```

### 使用

在 Claude Code 中直接描述你的需求，相关技能会自动触发：

```
用户: 我想做一个用户登录功能，帮我评估一下值不值得做
→ 触发 office-hours

用户: 帮我写一个 PRD
→ 触发 write-a-prd

用户: 用 TDD 实现这个功能
→ 触发 tdd
```

### 创建自定义技能

使用 `write-a-skill` 创建个人技能：

```
用户: 帮我创建一个技能，用于生成 API 文档
→ 触发 write-a-skill
```

---

## 目录结构

```
DDAi/
├── plugins/                    # 插件目录
│   ├── office-hours/          # 需求价值诊断
│   ├── write-a-prd/           # PRD 编写
│   ├── prd-to-plan/           # PRD 转计划
│   ├── prd-to-issues/         # PRD 转 issue
│   ├── design-an-interface/   # 接口设计
│   ├── grill-me/              # 计划压力测试
│   ├── ubiquitous-language/   # 统一语言
│   ├── improve-architecture/  # 架构改进
│   ├── request-refactor-plan/ # 重构计划
│   ├── tdd/                   # 测试驱动开发
│   ├── quick-commit/          # 规范化提交
│   ├── triage-issue/          # 问题排查
│   ├── write-a-skill/         # 创建技能
│   ├── edit-article/          # 文章编辑
│   └── make-dialogue-style/   # 对话风格配置
├── .claude/
│   └── skills/                # 全局技能
│       ├── write-ddai-skill/  # 创建 DDAi 插件
│       └── ddai-commit/       # DDAi 专用提交
├── CLAUDE.md                  # 项目规范
└── README.md                  # 本文件
```

---

## 贡献

欢迎贡献新插件或改进现有插件。请参考：

- [write-ddai-skill](/.claude/skills/write-ddai-skill/) - 创建 DDAi 插件指南
- [CLAUDE.md](/CLAUDE.md) - 语气措辞规范

---

## License

MIT
