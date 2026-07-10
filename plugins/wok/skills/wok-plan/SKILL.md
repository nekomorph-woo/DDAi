---
name: wok-plan
description: 将模块设计翻译为编码执行计划，定义文件顺序、集成点和每步验证标准。Use when 用户要求制定开发计划、编写执行步骤、拆分编码任务，或提到 "wok-plan" / "开发计划" / "执行计划"。
pipeline:
  upstream: [wok-design-review]
  downstream: [wok-execute]
  gate: true
  output: document
  adaptive: true
---

# 执行计划

将模块设计翻译为可执行的编码步骤，与 TDD 衔接。

## 命令接口

`/wok-plan [--refresh]`

| 参数 | 格式 | 说明 |
|------|------|------|
| `--refresh` | flag | 增量刷新：仅重新生成受上游变更影响的步骤，保留未受影响步骤 |

当用户消息中包含 "refresh" 或 "增量刷新" 时，按此模式执行。

## 快速开始

1. 读取 `_check.md` 确认无阻塞项
2. 读取各模块 `design.md` 提取接口
3. 生成执行计划

## 工作流程

### 1. 读取上游（可选）

> 读取 `~/.claude/wok/resolve-system-name.md` 执行 system-name 解析。

> `<phase-dir>` 指 `_define.md` 所在目录。无 roadmap 时为 `.wok-plans/<system-name>/`，有 roadmap 时为 `.wok-plans/<system-name>/p<n>-<phase>/`。

- 读取 `<phase-dir>/_check.md` — 如有 🔴 阻塞项，提示先解决；文件不存在则跳过
- 读取 `<phase-dir>/modules/_registry.md` — 获取模块列表和依赖顺序；文件不存在则从代码库识别
- 读取各模块 `design.md` — 提取接口契约和实现约束；文件不存在则从代码库和对话上下文推断

**`--refresh` 模式**：

1. 读取现有 `_plan.md`，解析已完成步骤（`[x]` 标记）
2. 读取各模块 `design.md` 的 `freshness` 字段
3. 分为：
   - **受影响步骤**：引用 `freshness` 为 `stale` / `impacted` 的模块的步骤
   - **未受影响步骤**：引用 `fresh` 模块的已完成步骤
4. 仅重新生成受影响步骤
5. 保留未受影响步骤的原始内容和完成状态

### 2. 确定执行顺序

根据依赖图确定编码顺序：

- 无依赖的模块先做
- 被依赖最多的模块优先
- 标注集成点（模块间的接口调用时刻）

**`--refresh` 模式**：使用 `/wok-grill-me` 让用户确认受影响/未受影响的步骤分类是否正确。

**非 refresh 模式**：使用 `/wok-grill-me` 让用户确认关键排序决策（当模块数 ≥ 3 时触发）。

### 3. 生成执行计划

产出 `<phase-dir>/_plan.md`：

> **📝 文风要求**（完整规范见 `skills/_shared/doc-writing-style.md`）：
> 1. 写完整句子，不写电报体——占位符都按例句的完整句式填充，不照抄例句文字
> 2. 术语首次出现就通俗解释（集成点、CHECKPOINT、TDD 等见下方术语说明）
> 3. step 标题的描述要写完整动作，如"实现用户登录接口"，不写"登录"

```markdown
---
status: draft
intent: action
scope: global
depends: [chk:<feature-name>]
changed: 初始版本
---

> **模块数**：N 个
> **执行步骤**：M 步（含 K 个审查点）
> **集成点**：J 个
> **阻塞**：<阻塞项>

## 执行顺序

### Step 1: [ ] [ACTION] <模块名> — <用一句话写清这步做什么，如"实现用户登录接口，含凭证校验与令牌签发">

- **文件**：<写明新建或修改的文件完整路径，如"新建 src/auth/login.ts，修改 src/router.ts">
- **接口**：<列出本步要实现的接口，如"POST /api/login、login(cred) → Token">
- **覆盖验收标准**：US-1 🤖①, US-2 🤖③
- **测试覆盖**：
  - 正常路径：<具体行为描述，如"有效凭证登录返回 200 和 JWT">
  - 边界条件：<具体行为描述，如"空密码、超长密码">
  - 异常路径：<具体行为描述，如"错误密码返回 401">

<details>
<summary>【实现约束】验证标准 + 集成说明</summary>

- **验证**：<如何验证这一步完成，如"npm test 跑 login.test.ts 全绿">
- **集成**：<这一步是否是某个集成点的前置，如"是 api-gateway 调用 login 的前置，需先定接口">

</details>

### Step 2: [ ] [ACTION] <模块名> — <一句话描述>
...

### Step 3: [ ] 🔍 [CHECKPOINT] code-review — review steps 1-2

- **审查范围**：steps 1-2 的所有变更
- **通过后**：批量回填 steps 1-2 为 [x]

<details>
<summary>【实现约束】checkpoint 验证标准</summary>

- **验证**：code-review 收敛且无 🔴 Open
- **回填**：autopilot 将本 group 的所有 [ ] → [x]

</details>

### Step 4: [ ] [ACTION] <模块名> — <一句话描述>
...
```

#### CHECKPOINT 插入策略

step 生成后，评估是否需要插入 CR checkpoint：

| 条件 | 插入时机 |
|------|----------|
| step 数 ≤ 3 | 仅末尾一个默认 checkpoint |
| 存在跨模块集成点 | 集成点后插入 checkpoint |
| 连续 ≥ 4 个同模块 step | 在第 4 个后插入 checkpoint |
| step 涉及外部依赖变更 | 变更后插入 checkpoint |

**判断原则**：当 n 个 step 的代码实现组合后比较完整时再 CR，不要频繁触发。

**CHECKPOINT 格式**：

```markdown
### Step N: [ ] 🔍 [CHECKPOINT] code-review — review steps <M>-<N-1>

- **审查范围**：steps <M>-<N-1> 的所有变更
- **通过后**：批量回填 steps <M>-<N-1> 为 [x]

<details>
<summary>【实现约束】checkpoint 验证标准</summary>

- **验证**：code-review 收敛且无 🔴 Open
- **回填**：autopilot 将本 group 的所有 [ ] → [x]

</details>
```

每个 CHECKPOINT 必须标注审查范围（step 区间）。默认至少一个末尾 CHECKPOINT。CHECKPOINT 不由 implement 执行，由 autopilot 在编排时处理。

**`--refresh` 模式**：frontmatter 添加 `changed: 增量刷新（受影响模块：<列表>）`。受影响步骤标记为 `[ ]`（未完成），未受影响步骤保留原文本和 `[x]` 状态。CHECKPOINT 步骤保持不变。

### 4. 补充检查项

对每个步骤补充检查维度（详见 reference/step-quality.md）：

- **跨模块集成点**：这一步是否引入了对其他模块的调用？
- **测试可行性**：这一步的验证标准是否能通过测试实现？
- **测试覆盖声明**：每个 ACTION step 必须声明三层测试覆盖（正常路径/边界条件/异常路径），缺任一层 → 生成警告
- **遗漏风险**：模块 design.md 中是否有未覆盖的接口或约束？
- **验收标准覆盖**：每个 🤖 验收标准（按 `US-N 🤖M` 全局唯一 ID）是否被至少一个 step 引用？未覆盖的 🤖 → 生成警告

### 5. 验证门

展示执行计划，用户确认后准备进入 TDD：

```
## ✅ 执行计划完成

**步骤数**：<M> 步（含 <K> 个审查点）
**集成点**：<J> 个
**遗漏风险**：<列出有风险的步骤>
**阻塞**：<阻塞项>
**下一步**：开始 TDD 编码
```

## 术语说明

- **集成点**：一个模块调用另一个模块接口的时刻——标记集成点是为了确保被调用方的接口已先实现，避免开发时才发现依赖缺失
- **CHECKPOINT**（检查点）：一组 step 完成后的代码审查节点——在此触发 wok-code-review，审查通过才把这组 step 回填为完成
- **ACTION step**：需要实际写代码的执行步骤；**CHECKPOINT step**：不写代码，只标记"此处审查"
- **TDD**（测试驱动开发）：先写测试看到失败（RED）→ 再写最小代码让它通过（GREEN）→ 最后重构（REFACTOR）

## 约束

- **DO NOT** 将执行计划拆分为独立 issue — 计划是一个整体，TDD 按步骤执行
- **DO NOT** 使用缩写标记（如 `A1`），必须使用完整 `### [ACTION]` 格式
- 每个步骤必须有明确的验证标准
- 集成点必须显式标注 — 隐藏的集成是开发遗漏的主要来源
- 每个 CHECKPOINT 必须标注审查范围（step 区间）
- CHECKPOINT 不由 implement 执行，由 autopilot 在编排时处理
- 每个 ACTION step 必须声明覆盖的验收标准（`**覆盖验收标准**` 字段）
- 每个 ACTION step 必须声明三层测试覆盖（`**测试覆盖**` 字段：正常路径/边界条件/异常路径），缺任一层 → 生成警告
- 所有 🤖 验收标准必须被至少一个 ACTION step 覆盖，未覆盖 → 生成警告
