#!/usr/bin/env bash
# install.sh - 跨平台安装脚本
# 用法: bash install.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 检测当前项目使用的 Agent
detect_agent() {
    if [ -d ".cursor" ]; then echo "cursor"
    elif [ -d ".windsurf" ]; then echo "windsurf"
    elif [ -f ".zed/tasks.json" ]; then echo "zed"
    elif [ -d ".claude" ]; then echo "claude-code"
    else echo "unknown"
    fi
}

# 复制文件到目标目录
install_to() {
    local target_dir="$1"
    mkdir -p "$target_dir"
    cp "$SCRIPT_DIR/learn-eval.md" "$target_dir/"
    echo "✓ 已安装到: $target_dir/"
}

echo "=== Agent Continuous Learning 安装脚本 ==="
echo ""

AGENT=$(detect_agent)
echo "检测到 Agent: $AGENT"
echo ""

case $AGENT in
    claude-code)
        install_to ~/.claude/commands
        echo ""
        echo "使用方法: /learn-eval"
        ;;
    cursor)
        install_to .cursor/commands
        echo ""
        echo "使用方法: 在 Cursor 中引用 .cursor/commands/learn-eval.md"
        ;;
    windsurf)
        install_to .windsurf/commands
        echo ""
        echo "使用方法: 在 Windsurf 中引用 .windsurf/commands/learn-eval.md"
        ;;
    *)
        echo "未检测到支持的 Agent"
        echo ""
        echo "手动安装："
        echo "  Claude Code: cp learn-eval.md ~/.claude/commands/"
        echo "  Cursor:      mkdir -p .cursor/commands && cp learn-eval.md .cursor/commands/"
        echo "  Windsurf:    mkdir -p .windsurf/commands && cp learn-eval.md .windsurf/commands/"
        echo ""
        echo "或指定目标安装："
        echo "  bash install.sh --claude    # 安装到 Claude Code"
        echo "  bash install.sh --cursor    # 安装到 Cursor"
        echo "  bash install.sh --windsurf  # 安装到 Windsurf"
        ;;
esac
