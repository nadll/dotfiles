# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

# iTerm2 loads every file in DynamicProfiles at startup and reloads them when they change
# https://iterm2.com/documentation-dynamic-profiles.html
link "$DOTFILES/iterm2/settings/profiles.json" "$HOME/Library/Application Support/iTerm2/DynamicProfiles/dotfiles.json"

# NOTE: color presets (iterm2/colors/) and the key map (iterm2/settings/keys.itermkeymap)
# are imported by hand, see README.md
