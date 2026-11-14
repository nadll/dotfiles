# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)
# Manages gpg-agent.conf and gpg.conf; keys (pubring.kbx, private-keys-v1.d/, trustdb.gpg)
# in ~/.gnupg are never touched, and neither is a gpg.conf you already had.

run mkdir -p "$HOME/.gnupg"
# gpg warns about "unsafe permissions" if others can read ~/.gnupg
run chmod 700 "$HOME/.gnupg"

agent_conf="$HOME/.gnupg/gpg-agent.conf"
pinentry_line=$(grep '^pinentry-program' "$DOTFILES/gpg/gpg-agent.conf")
if [ -f "$agent_conf" ] && [ ! -L "$agent_conf" ]; then
  # An existing gpg-agent.conf (from before these dotfiles) is kept as it is, so none of its
  # settings are lost; only the pinentry-mac line is added when it has no pinentry-program yet.
  if grep -qxF "$pinentry_line" "$agent_conf"; then
    : # already has the same pinentry-program line
  elif grep -q '^[[:space:]]*pinentry-program' "$agent_conf"; then
    warn "Keeping your own ~/.gnupg/gpg-agent.conf (it already sets pinentry-program; repo: $pinentry_line)"
  else
    info "Adding '$pinentry_line' to your existing ~/.gnupg/gpg-agent.conf"
    run cp -p "$agent_conf" "$agent_conf.backup.$(date +%Y%m%d%H%M%S)"
    if [ "$DRY_RUN" = 0 ]; then
      printf '\n# Added by dotfiles gpg/configure.sh\n%s\n' "$pinentry_line" >> "$agent_conf"
    fi
  fi
else
  link "$DOTFILES/gpg/gpg-agent.conf" "$agent_conf"
fi

# gpg.conf: linked only when there is none yet; your own gpg.conf (a real file) is kept as it is
gpg_conf="$HOME/.gnupg/gpg.conf"
if [ -f "$gpg_conf" ] && [ ! -L "$gpg_conf" ]; then
  warn "Keeping your own ~/.gnupg/gpg.conf (compare it with $(pretty "$DOTFILES/gpg/gpg.conf"))"
else
  link "$DOTFILES/gpg/gpg.conf" "$gpg_conf"
fi

link "$DOTFILES/gpg/gpg.rc.sh" "$SHELLRCDIR/"

# Restart the agent (if gpg is installed) so it reads the new config
if command -v gpgconf >/dev/null 2>&1; then
  run gpgconf --kill gpg-agent
fi
