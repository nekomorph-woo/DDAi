#!/bin/bash

# init-skill.sh - 快速创建 DDAi 插件骨架
# 用法: init-skill.sh <plugin-name>

set -e

SKILL_NAME="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DDAI_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
TARGET_DIR="$DDAI_ROOT/plugins"

if [ -z "$SKILL_NAME" ]; then
    echo "用法: init-skill.sh <plugin-name>"
    echo ""
    echo "参数:"
    echo "  plugin-name  插件名称（使用 kebab-case）"
    echo ""
    echo "示例:"
    echo "  init-skill.sh my-plugin"
    echo "  init-skill.sh api-client"
    exit 1
fi

# 验证插件名称格式
if ! [[ "$SKILL_NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
    echo "错误: 插件名称必须使用 kebab-case（小写字母、数字、连字符）"
    echo "示例: my-plugin, api-client, json-formatter"
    exit 1
fi

SKILL_PATH="$TARGET_DIR/$SKILL_NAME"

# 检查目录是否已存在
if [ -d "$SKILL_PATH" ]; then
    echo "错误: 插件目录已存在: $SKILL_PATH"
    exit 1
fi

# 创建三层目录结构
mkdir -p "$SKILL_PATH/.claude-plugin"
mkdir -p "$SKILL_PATH/commands"
mkdir -p "$SKILL_PATH/skills/$SKILL_NAME/reference"
mkdir -p "$SKILL_PATH/skills/$SKILL_NAME/examples"
mkdir -p "$SKILL_PATH/skills/$SKILL_NAME/scripts"

# 创建 plugin.json
cat > "$SKILL_PATH/.claude-plugin/plugin.json" << EOF
{
  "name": "$SKILL_NAME",
  "version": "0.1.0"
}
EOF

# 创建 commands 入口
cat > "$SKILL_PATH/commands/$SKILL_NAME.md" << EOF
---
name: $SKILL_NAME
description: 能力简述。Use when [具体触发条件]。
---

执行 [$SKILL_NAME 技能](../skills/$SKILL_NAME/SKILL.md) 的完整流程。
EOF

# 创建 SKILL.md 模板
cat > "$SKILL_PATH/skills/$SKILL_NAME/SKILL.md" << 'EOF'
---
name: SKILL_NAME_PLACEHOLDER
description: 能力简述。Use when [具体触发条件]。
---

# 插件名称

## 快速开始

提供最简可运行示例。

## 工作流程

复杂任务分步执行并检查。

## 高级功能

详见 [reference/](reference/)。
EOF

# 替换插件名称
sed -i '' "s/SKILL_NAME_PLACEHOLDER/$SKILL_NAME/g" "$SKILL_PATH/skills/$SKILL_NAME/SKILL.md"

# 创建 .gitkeep 保持空目录
touch "$SKILL_PATH/skills/$SKILL_NAME/reference/.gitkeep"
touch "$SKILL_PATH/skills/$SKILL_NAME/examples/.gitkeep"
touch "$SKILL_PATH/skills/$SKILL_NAME/scripts/.gitkeep"

echo "✓ DDAi 插件骨架已创建: $SKILL_PATH"
echo ""
echo "目录结构:"
echo "  $SKILL_PATH/"
echo "  ├── .claude-plugin/"
echo "  │   └── plugin.json"
echo "  ├── commands/"
echo "  │   └── $SKILL_NAME.md"
echo "  └── skills/"
echo "      └── $SKILL_NAME/"
echo "          ├── SKILL.md"
echo "          ├── reference/"
echo "          ├── examples/"
echo "          └── scripts/"
echo ""
echo "下一步:"
echo "  1. 编辑 skills/$SKILL_NAME/SKILL.md 填充插件内容"
echo "  2. 更新 commands/$SKILL_NAME.md 的 description"
echo "  3. 在 .claude-plugin/marketplace.json 中添加插件条目"
