# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

run mkdir -p "$HOME/.ssh"
# ssh refuses keys and config that other users can read
run chmod 700 "$HOME/.ssh"

# ~/.ssh/config is a link to the repo; machine-specific hosts go in ~/.ssh/config.local (included at its top).
# A real ~/.ssh/config from before becomes config.local, so its hosts keep working.
if [ -f "$HOME/.ssh/config" ] && [ ! -L "$HOME/.ssh/config" ] && [ ! -e "$HOME/.ssh/config.local" ]; then
  info "Moving your old ~/.ssh/config to ~/.ssh/config.local"
  run mv "$HOME/.ssh/config" "$HOME/.ssh/config.local"
fi
link "$DOTFILES/ssh/config" "$HOME/.ssh/config"
# ssh rejects a config that others can write to (it checks the repo file behind the link)
run chmod 600 "$DOTFILES/ssh/config"
if [ -f "$HOME/.ssh/config.local" ]; then
  run chmod 600 "$HOME/.ssh/config.local"
fi

link "$DOTFILES/ssh/ssh.rc.sh" "$SHELLRCDIR/"
