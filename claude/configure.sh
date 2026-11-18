# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

# Claude Code user settings and global instructions (all projects).
# Claude Code writes to settings.json itself (/config, theme): through the link those
# changes land in the repo, check `git status`. ~/.claude.json (login, project history)
# stays out of the repo.
link "$DOTFILES/claude/settings.json" "$HOME/.claude/settings.json"
link "$DOTFILES/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
# status line script, set as "statusLine" in settings.json
link "$DOTFILES/claude/statusline.sh" "$HOME/.claude/statusline.sh"
# hook scripts, set in "hooks" in settings.json
link "$DOTFILES/claude/hooks/stop-notify.sh" "$HOME/.claude/hooks/stop-notify.sh"
link "$DOTFILES/claude/hooks/format-python.sh" "$HOME/.claude/hooks/format-python.sh"
# custom theme, selected as "theme": "custom:catppuccin-mocha" in settings.json
link "$DOTFILES/claude/themes/catppuccin-mocha.json" "$HOME/.claude/themes/catppuccin-mocha.json"
# user-scope MCP servers from claude/mcp/*.json, added only if missing
if command -v claude >/dev/null; then
  for f in "$DOTFILES"/claude/mcp/*.json; do
    [ -e "$f" ] || continue
    name=$(basename "$f" .json)
    claude mcp get "$name" >/dev/null 2>&1 ||
      claude mcp add-json --scope user "$name" "$(cat "$f")"
  done
fi
