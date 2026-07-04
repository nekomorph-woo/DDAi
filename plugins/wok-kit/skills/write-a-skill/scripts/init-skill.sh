#!/bin/bash

# init-skill.sh - 按目标端创建技能骨架
# 用法: init-skill.sh <skill-name> <target-ide> [location] [project-dir]
#   target-ide: cc（Claude Code）/ cursor / codex
#   location:   global（默认）或 project（cursor 仅项目级）

set -e

SKILL_NAME="$1"
TARGET_IDE="$2"
LOCATION_TYPE="${3:-global}"
PROJECT_DIR="${4:-$(pwd)}"

if [ -z "$SKILL_NAME" ] || [ -z "$TARGET_IDE" ]; then
    echo "用法: init-skill.sh <skill-name> <target-ide> [location] [project-dir]"
    echo ""
    echo "参数:"
    echo "  skill-name   技能名称（kebab-case）"
    echo "  target-ide   目标端：cc（Claude Code）/ cursor / codex"
    echo "  location     存放位置：global（默认）或 project"
    echo "  project-dir  项目目录（仅 location=project 时使用，默认当前目录）"
    echo ""
    echo "示例:"
    echo "  init-skill.sh my-skill cc                # Claude Code 全局技能"
    echo "  init-skill.sh my-skill cc project        # Claude Code 项目技能"
    echo "  init-skill.sh my-skill cursor            # Cursor 项目级 rule（cursor 仅项目级）"
    echo "  init-skill.sh my-skill codex project     # Codex 项目级 agent"
    exit 1
fi

# 验证技能名称格式
if ! [[ "$SKILL_NAME" =~ ^[a-z][a-z0-9-]*$ ]]; then
    echo "错误: 技能名称必须使用 kebab-case（小写字母、数字、连字符）"
    echo "示例: my-skill, api-client, json-formatter"
    exit 1
fi

# 根据目标端决定目录、文件路径
case "$TARGET_IDE" in
    cc)
        case "$LOCATION_TYPE" in
            project) TARGET_DIR="$PROJECT_DIR/.claude/skills" ;;
            global|*) TARGET_DIR="$HOME/.claude/skills" ;;
        esac
        SKILL_PATH="$TARGET_DIR/$SKILL_NAME"
        FILE_PATH="$SKILL_PATH/SKILL.md"
        ;;
    cursor)
        # Cursor 无 skill 机制，降级为 rule；仅项目级
        TARGET_DIR="$PROJECT_DIR/.cursor/rules"
        SKILL_PATH="$TARGET_DIR"
        FILE_PATH="$TARGET_DIR/$SKILL_NAME.mdc"
        ;;
    codex)
        case "$LOCATION_TYPE" in
            project) TARGET_DIR="$PROJECT_DIR/.codex/agents" ;;
            global|*) TARGET_DIR="$HOME/.codex/agents" ;;
        esac
        SKILL_PATH="$TARGET_DIR"
        FILE_PATH="$TARGET_DIR/$SKILL_NAME.toml"
        ;;
    *)
        echo "错误: target-ide 必须是 cc / cursor / codex"
        exit 1
        ;;
esac

# 检查文件是否已存在
if [ -f "$FILE_PATH" ]; then
    echo "错误: 技能文件已存在: $FILE_PATH"
    exit 1
fi

# 创建目录
mkdir -p "$SKILL_PATH"

# 按端创建骨架文件
case "$TARGET_IDE" in
    cc)
        mkdir -p "$SKILL_PATH/reference" "$SKILL_PATH/examples" "$SKILL_PATH/scripts"
        cat > "$FILE_PATH" << EOF
---
name: $SKILL_NAME
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
        touch "$SKILL_PATH/reference/.gitkeep" "$SKILL_PATH/examples/.gitkeep" "$SKILL_PATH/scripts/.gitkeep"
        ;;
    cursor)
        cat > "$FILE_PATH" << EOF
---
description: 能力简述。Use when [具体触发条件]。
globs: ""
alwaysApply: false
---

# 技能名称

## 快速开始

提供最简可运行示例。

## 工作流程

复杂任务分步执行并检查。
EOF
        ;;
    codex)
        cat > "$FILE_PATH" << EOF
name = "$SKILL_NAME"
description = "能力简述。Use when [具体触发条件]。"
developer_instructions = """
# 技能名称

## 快速开始

提供最简可运行示例。

## 工作流程

复杂任务分步执行并检查。
"""
EOF
        ;;
esac

echo "✓ 技能骨架已创建: $FILE_PATH"
echo ""
echo "目标端: $TARGET_IDE"
echo "下一步: 编辑 $FILE_PATH 填充技能内容"
