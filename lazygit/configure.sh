# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

# lazygit's config folder on macOS (it uses $XDG_CONFIG_HOME/lazygit instead when that is set)
link "$DOTFILES/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"
