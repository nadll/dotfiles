#!/usr/bin/env bash
# Set up Claude Code inside an sbx sandbox (Linux VM with its own ~/.claude). Run it once
# per sandbox from the mounted repo:  ./claude/sandbox-init.sh   (safe to re-run).
# Not run by install.sh (that only runs */configure.sh, on the Mac).
#
# - links theme, status line, CLAUDE.md and the Python format hook to the repo files,
#   so later repo edits show up in the sandbox too
# - merges a light subset of claude/settings.json into the sandbox's OWN settings.json
#   (keeps the keys sbx wrote there, e.g. permissions.defaultMode, bypass flags)
#
# Left out on purpose: permissions.allow (sbx runs in auto/bypass mode),
# disableBypassPermissionsMode (would block sbx), the Claude sandbox (sbx is the sandbox),
# the Stop/Notification hooks (macOS only: osascript, afplay) and the MCP servers.
set -euo pipefail

DOTFILES=$(cd "$(dirname "$0")/.." && pwd)
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

if ! command -v jq >/dev/null 2>&1; then
  echo "sandbox-init: jq is needed (settings merge and status line)" >&2
  exit 1
fi

link() {
  local src=$1 target=$2
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
    return
  fi
  mkdir -p "$(dirname "$target")"
  if [ -e "$target" ] || [ -L "$target" ]; then
    mv "$target" "$target.bak.$(date +%Y%m%d%H%M%S)"
    echo "backed up $target"
  fi
  ln -s "$src" "$target"
  echo "linked $target -> $src"
}

link "$DOTFILES/claude/themes/catppuccin-mocha.json" "$CLAUDE_DIR/themes/catppuccin-mocha.json"
link "$DOTFILES/claude/statusline.sh" "$CLAUDE_DIR/statusline.sh"
link "$DOTFILES/claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
link "$DOTFILES/claude/hooks/format-python.sh" "$CLAUDE_DIR/hooks/format-python.sh"

# settings.json: the sandbox's own file must stay a real file (sbx owns it)
if [ -L "$SETTINGS" ]; then
  echo "sandbox-init: $SETTINGS is a symlink; not touching it" >&2
  exit 1
fi
[ -f "$SETTINGS" ] || echo '{}' >"$SETTINGS"

light=$(jq '{
    cleanupPeriodDays, env, attribution, feedbackSurveyRate, alwaysThinkingEnabled,
    theme, statusLine,
    permissions: { deny: .permissions.deny, ask: .permissions.ask },
    hooks: { PostToolUse: .hooks.PostToolUse }
  } | with_entries(select(.value != null))' "$DOTFILES/claude/settings.json")

tmp=$(mktemp "$SETTINGS.XXXXXX")
jq --argjson light "$light" '. * $light' "$SETTINGS" >"$tmp"
if cmp -s "$tmp" "$SETTINGS"; then
  rm -f "$tmp"
  echo "settings.json already up to date"
else
  cp "$SETTINGS" "$SETTINGS.bak.$(date +%Y%m%d%H%M%S)"
  mv "$tmp" "$SETTINGS"
  echo "merged repo settings into $SETTINGS (backup kept)"
fi

echo "done: restart claude in this sandbox to see the theme and status line"
