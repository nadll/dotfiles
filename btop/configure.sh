# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

# Catppuccin Mocha theme from https://github.com/catppuccin/btop (MIT).
# btop rewrites btop.conf on exit, so the theme is only installed here:
# pick it once in btop (Esc -> Options -> Color theme: catppuccin_mocha).
link "$DOTFILES/btop/themes/catppuccin_mocha.theme" "$HOME/.config/btop/themes/"
