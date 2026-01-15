#!/bin/bash
# 全局配置扫描脚本

CLAUDE_DIR="$HOME/.claude"

# 获取 skills 列表（只获取目录）
skills=""
if [ -d "$CLAUDE_DIR/skills" ]; then
    for d in "$CLAUDE_DIR/skills"/*/; do
        [ -d "$d" ] && skills="$skills,\"$(basename "$d")\""
    done
fi
skills="${skills#,}"

# 获取 plugins 列表（只获取目录）
plugins=""
if [ -d "$CLAUDE_DIR/plugins" ]; then
    for d in "$CLAUDE_DIR/plugins"/*/; do
        [ -d "$d" ] && plugins="$plugins,\"$(basename "$d")\""
    done
fi
plugins="${plugins#,}"

# 检查 MCP 配置
has_mcp="false"
[ -f "$HOME/.claude.json" ] && has_mcp="true"

# 输出 JSON
echo "{"
echo "  \"skills\": [$skills],"
echo "  \"plugins\": [$plugins],"
echo "  \"has_mcp_config\": $has_mcp"
echo "}"
