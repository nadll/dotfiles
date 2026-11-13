#!/bin/sh
# Claude Code "PostToolUse" hook (Edit|Write|MultiEdit): format a Python file Claude just
# changed with ruff, like VS Code does when you save. ruff reads the project's own settings
# (pyproject.toml / ruff.toml). Uses `ruff` if installed, else `uv tool run ruff` (= uvx); otherwise nothing.
# Linked to ~/.claude/hooks/format-python.sh by claude/configure.sh.
file=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)
case $file in
  *.py | *.pyi) ;;
  *) exit 0 ;;
esac
[ -f "$file" ] || exit 0
if command -v ruff >/dev/null 2>&1; then
  ruff format --quiet "$file"
elif command -v uv >/dev/null 2>&1; then
  uv tool run --quiet ruff format --quiet "$file"
fi >/dev/null 2>&1
exit 0
