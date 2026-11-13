# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

link "$DOTFILES/python/python.rc.sh" "$SHELLRCDIR/"

# 7-day cooldown on new package versions (see the comments in uv.toml)
link "$DOTFILES/python/uv.toml" "$HOME/.config/uv/uv.toml"
