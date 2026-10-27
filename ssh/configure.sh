# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

run mkdir -p "$HOME/.ssh"
# ssh refuses keys and config that other users can read
run chmod 700 "$HOME/.ssh"

if [ ! -f "$HOME/.ssh/config" ]; then
  run cp "$DOTFILES/ssh/config" "$HOME/.ssh/config"
fi
run chmod 600 "$HOME/.ssh/config"

link "$DOTFILES/ssh/ssh.rc.sh" "$SHELLRCDIR/"
