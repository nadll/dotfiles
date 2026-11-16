# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

# Catppuccin Mocha theme from https://github.com/catppuccin/bat (MIT), used by BAT_THEME in coreutils/coreutils.rc.sh.
# bat reads themes from ~/.config/bat/themes (also on macOS) and needs its cache rebuilt to see them.
link "$DOTFILES/bat/themes/Catppuccin Mocha.tmTheme" "$HOME/.config/bat/themes/"
if command -v bat >/dev/null; then
  run bat cache --build
fi
