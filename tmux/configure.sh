# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

link "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"

# Tmux plugin manager, in the default location that tmux.conf runs it from
clone_or_update https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

# earlier versions exported TMUX_PLUGIN_MANAGER_PATH="$DOTFILES/vendor/tpm", which didn't match tmux.conf
if [ -e "$SHELLRCDIR/tmux.rc.sh" ]; then
  run rm "$SHELLRCDIR/tmux.rc.sh"
fi

# Install the plugins listed in tmux.conf (@plugin lines) that are missing; works without a
# running tmux. Already installed plugins are left as they are (update them with prefix+U).
# By hand: ~/.tmux/plugins/tpm/bin/install_plugins, or prefix+I inside tmux.
if command -v tmux >/dev/null 2>&1; then
  run "$HOME/.tmux/plugins/tpm/bin/install_plugins"
else
  warn "tmux not installed yet: install its plugins later with ~/.tmux/plugins/tpm/bin/install_plugins"
fi
# (was: install all plugins manually with <prefix>+I when opening tmux for the first time)

# helper scripts bound in tmux.conf
link "$DOTFILES/tmux/scripts/popup.sh" "$HOME/.tmux/scripts/popup.sh"
link "$DOTFILES/tmux/scripts/switch-pane.sh" "$HOME/.tmux/scripts/switch-pane.sh"
link "$DOTFILES/tmux/scripts/swap.sh" "$HOME/.tmux/scripts/swap.sh"
link "$DOTFILES/tmux/yank.sh" "$HOME/.tmux/scripts/yank.sh"
link "$DOTFILES/tmux/renew_env.sh" "$HOME/.tmux/scripts/renew_env.sh"
