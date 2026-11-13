# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

run mkdir -p "$HOME/.gnupg"
# gpg warns about "unsafe permissions" if others can read ~/.gnupg
run chmod 700 "$HOME/.gnupg"
link "$DOTFILES/gpg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
link "$DOTFILES/gpg/gpg.rc.sh" "$SHELLRCDIR/"

# Restart the agent (if gpg is installed) so it reads the new config
if command -v gpgconf >/dev/null 2>&1; then
  run gpgconf --kill gpg-agent
fi
