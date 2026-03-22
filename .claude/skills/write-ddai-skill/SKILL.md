---
name: write-ddai-skill
description: 创建 DDAi marketplace 插件，包含完整结构、渐进式信息展示和配套资源。Use when 用户要求创建、编写或开发 DDAi 插件，或提到 "DDAi plugin" / "DDAi 插件" / "marketplace plugin"。
---

# DDAi 插件编写指南

辅助用户创建 DDAi marketplace 插件。

## 流程

1. **收集需求** - 确认：
   - 插件覆盖的任务/领域
   - 需要处理的具体场景
   - 是否需要可执行脚本或仅指令
   - 是否需要包含参考材料

2. **创建插件骨架** - 执行：
   ```bash
   scripts/init-skill.sh <plugin-name>
   ```

3. **起草内容** - 填充：
   - `skills/<name>/SKILL.md`：精简指令
   - `commands/<name>.md`：更新 description
   - `skills/<name>/reference/`：详细文档（内容超过 100 行时）
   - `skills/<name>/examples/`：使用示例
   - `skills/<name>/scripts/`：确定性操作脚本

4. **处理资源文件** - 用户提供资源文件（模板、参考文档等）时：
   - 拷贝到对应目录：参考文档 → `skills/<name>/reference/`，示例 → `skills/<name>/examples/`，脚本 → `skills/<name>/scripts/`
   - 在 SKILL.md 中使用相对路径引用
   - 确保插件自包含，不依赖外部文件路径

5. **更新 marketplace.json** - 在 `.claude-plugin/marketplace.json` 中注册插件：
   ```json
   {
     "name": "plugin-name",
     "source": "./plugins/plugin-name",
     "description": "插件描述",
     "version": "0.1.0"
   }
   ```

6. **确认需求** - 展示草稿并验证：
   - 是否覆盖目标场景
   - 是否有遗漏或模糊之处
   - 各部分详略是否恰当

## 插件结构

```
plugins/<name>/
├── .claude-plugin/
│   └── plugin.json          # 插件清单（必需）
├── commands/
│   └── <name>.md            # 斜杠命令入口（必需）
└── skills/
    └── <name>/
        ├── SKILL.md         # 主指令文件（必需）
        ├── reference/       # 详细文档目录（按需）
        │   └── *.md
        ├── examples/        # 使用示例目录（按需）
        │   └── *.md
        └── scripts/         # 工具脚本目录（按需）
            └── helper.*     # bash/py/ts
```

## 示例

- [基础插件结构](examples/basic-plugin.md)

## plugin.json 模板

```json
{
  "name": "<name>",
  "version": "0.1.0"
}
```

## commands/<name>.md 模板

```md
---
name: <name>
description: 能力简述。Use when [具体触发条件]。
---

执行 [<name> 技能](../skills/<name>/SKILL.md) 的完整流程。
```

## SKILL.md 模板

```md
---
name: <name>
description: 能力简述。Use when [具体触发条件]。
---

# 技能名称

## 快速开始

提供最简可运行示例。

## 工作流程

复杂任务分步执行并检查。

## 高级功能

详见 [reference/](reference/)。
```

## 描述规范

描述决定 Agent 技能选择。Agent 读取技能描述匹配用户请求。

**目标**：让 Agent 明确：
1. 该技能提供什么能力
2. 何时/为何触发（关键词、上下文、文件类型）

**格式要求**：

- 最多 1024 字符
- 第三人称描述
- 第一句：描述能力
- 第二句："Use when [具体触发条件]"

**正确示例**：

```
提取 PDF 文件中的文本和表格，填充表单，合并文档。Use when 处理 PDF 文件，或用户提到 PDF、表单、文档提取。
```

**错误示例**：

```
帮助处理文档。
```

错误示例不区分技能差异。

## 语气措辞规范

遵循 `CLAUDE.md` 中的规范：

| 要求 | 说明 |
|------|------|
| **命令式** | 使用祈使句，直接指示动作 |
| **第三人称** | 描述技能能力，不用 "I will..." / "我会..." |
| **直接简洁** | 不使用 "Please try to..." / "你可以尝试..." |
| **克制专业** | 避免华丽辞藻，用词精准无歧义 |

详见 [reference/tone-guide.md](reference/tone-guide.md)。

## 添加脚本条件

满足以下条件时添加脚本：

- 操作具有确定性（验证、格式化）
- 相同代码会被重复生成
- 需要显式错误处理

脚本比生成代码更节省 token 且更可靠。

## 脚本语言选择

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

## 拆分文件条件

满足以下条件时拆分为独立文件：

- SKILL.md 超过 100 行
- 内容涉及不同领域（如财务 vs 销售模式）
- 高级功能较少使用

## 检查清单

验证项目：

- [ ] `.claude-plugin/plugin.json` 存在且格式正确
- [ ] `commands/<name>.md` 存在且引用正确
- [ ] `skills/<name>/SKILL.md` 存在
- [ ] 描述包含触发条件（"Use when..."）
- [ ] SKILL.md 控制在 100 行以内
- [ ] 移除时效性信息
- [ ] 统一术语使用
- [ ] 提供具体示例
- [ ] 限制引用层级（1 层以内）
- [ ] 版本号设置为 0.1.0
- [ ] 已在 marketplace.json 中注册
