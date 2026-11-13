# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

link "$DOTFILES/python/python.rc.sh" "$SHELLRCDIR/"

# 7-day cooldown on new package versions, for uv and pip (see the comments in both files)
link "$DOTFILES/python/uv.toml" "$HOME/.config/uv/uv.toml"
link "$DOTFILES/python/pip.conf" "$HOME/.config/pip/pip.conf"
# On macOS pip reads this one instead of ~/.config/pip/pip.conf when the folder exists
if [ -d "$HOME/Library/Application Support/pip" ]; then
  link "$DOTFILES/python/pip.conf" "$HOME/Library/Application Support/pip/pip.conf"
fi
