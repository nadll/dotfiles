# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

link "$DOTFILES/brew/brew.env.sh" "$SHELLENVDIR/"
link "$DOTFILES/brew/brew.rc.sh" "$SHELLRCDIR/"

# for newer versions of brew
# put brew env var file in dedicated location
if [ "${HOMEBREW_PREFIX:-}" = "/opt/homebrew" ]; then
  link "$DOTFILES/brew/brew.env" "$HOMEBREW_PREFIX/etc/homebrew/brew.env"
fi
