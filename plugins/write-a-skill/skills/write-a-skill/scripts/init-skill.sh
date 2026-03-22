#!/bin/bash

# init-skill.sh - 快速创建 DDAi 插件骨架
# 用法: init-skill.sh <plugin-name> [plugins-dir]

set -e

PLUGIN_NAME="$1"
PLUGINS_DIR="${2:-./plugins}"

if [ -z "$PLUGIN_NAME" ]; then
    echo "用法: init-skill.sh <plugin-name> [plugins-dir]"
    echo ""
    echo "参数:"
    echo "  plugin-name  插件名称（使用 kebab-case）"
    echo "  plugins-dir  插件目录（默认: ./plugins）"
    echo ""
    echo "示例:"
    echo "  init-skill.sh my-plugin"
    echo "  init-skill.sh my-plugin /path/to/plugins"
    exit 1
fi

# 验证插件名称格式
if ! [[ "$PLUGIN_NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
    echo "错误: 插件名称必须使用 kebab-case（小写字母、数字、连字符）"
    echo "示例: my-plugin, api-client, json-formatter"
    exit 1
fi

PLUGIN_PATH="$PLUGINS_DIR/$PLUGIN_NAME"

# 检查目录是否已存在
if [ -d "$PLUGIN_PATH" ]; then
    echo "错误: 插件目录已存在: $PLUGIN_PATH"
    exit 1
fi

# 创建三层目录结构
mkdir -p "$PLUGIN_PATH/.claude-plugin"
mkdir -p "$PLUGIN_PATH/commands"
mkdir -p "$PLUGIN_PATH/skills/$PLUGIN_NAME/reference"
mkdir -p "$PLUGIN_PATH/skills/$PLUGIN_NAME/examples"
mkdir -p "$PLUGIN_PATH/skills/$PLUGIN_NAME/scripts"

# 创建 plugin.json
cat > "$PLUGIN_PATH/.claude-plugin/plugin.json" << EOF
{
  "name": "$PLUGIN_NAME",
  "version": "0.1.0"
}
EOF

# 创建 commands 入口
cat > "$PLUGIN_PATH/commands/$PLUGIN_NAME.md" << EOF
---
name: $PLUGIN_NAME
description: 能力简述。Use when [具体触发条件]。
---

执行 [$PLUGIN_NAME 技能](../skills/$PLUGIN_NAME/SKILL.md) 的完整流程。
EOF

# 创建 SKILL.md 模板
cat > "$PLUGIN_PATH/skills/$PLUGIN_NAME/SKILL.md" << 'EOF'
---
name: SKILL_NAME_PLACEHOLDER
description: 能力简述。Use when [具体触发条件]。
---

# 技能名称

## 快速开始

提供最简可运行示例。

## 工作流程

复杂任务分步执行并检查。

## 高级功能

详见 [reference/](reference/)。
EOF

# 替换技能名称
sed -i '' "s/SKILL_NAME_PLACEHOLDER/$PLUGIN_NAME/g" "$PLUGIN_PATH/skills/$PLUGIN_NAME/SKILL.md"

# 创建 .gitkeep 保持空目录
touch "$PLUGIN_PATH/skills/$PLUGIN_NAME/reference/.gitkeep"
touch "$PLUGIN_PATH/skills/$PLUGIN_NAME/examples/.gitkeep"
touch "$PLUGIN_PATH/skills/$PLUGIN_NAME/scripts/.gitkeep"

echo "✓ DDAi 插件骨架已创建: $PLUGIN_PATH"
echo ""
echo "目录结构:"
echo "  $PLUGIN_PATH/"
echo "  ├── .claude-plugin/"
echo "  │   └── plugin.json"
echo "  ├── commands/"
echo "  │   └── $PLUGIN_NAME.md"
echo "  └── skills/"
echo "      └── $PLUGIN_NAME/"
echo "          ├── SKILL.md"
echo "          ├── reference/"
echo "          ├── examples/"
echo "          └── scripts/"
echo ""
echo "下一步:"
echo "  1. 编辑 skills/$PLUGIN_NAME/SKILL.md 填充技能内容"
echo "  2. 更新 commands/$PLUGIN_NAME.md 的 description"
echo "  3. 在 marketplace.json 中添加插件条目"
