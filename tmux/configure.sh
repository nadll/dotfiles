# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

link "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"

# Tmux plugin manager, in the default location that tmux.conf runs it from
clone_or_update https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

# earlier versions exported TMUX_PLUGIN_MANAGER_PATH="$DOTFILES/vendor/tpm", which didn't match tmux.conf
if [ -e "$SHELLRCDIR/tmux.rc.sh" ]; then
  run rm "$SHELLRCDIR/tmux.rc.sh"
fi

# NOTE: when opening Tmux for the first time, make sure to install all plugins manually (<prefix>+I)
# (same after adding a plugin to tmux.conf, e.g. tmux-resurrect and tmux-continuum)

# helper scripts bound in tmux.conf
link "$DOTFILES/tmux/scripts/popup.sh" "$HOME/.tmux/scripts/popup.sh"
link "$DOTFILES/tmux/scripts/switch-pane.sh" "$HOME/.tmux/scripts/switch-pane.sh"
