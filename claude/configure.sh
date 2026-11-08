# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

# Claude Code user settings and global instructions (all projects).
# Claude Code writes to settings.json itself (/config, theme): through the link those
# changes land in the repo, check `git status`. ~/.claude.json (login, project history)
# stays out of the repo.
link "$DOTFILES/claude/settings.json" "$HOME/.claude/settings.json"
link "$DOTFILES/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
