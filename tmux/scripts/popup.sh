#!/bin/sh
# Toggle a floating scratch terminal (tmux 3.2+), bound to prefix + ` in tmux.conf.
# Opens a popup over the current window, attached to a persistent session named "popup"
# (started in the current pane's folder); the same keys inside the popup hide it again.
# Whatever runs in the popup keeps running while it is hidden.
# Linked to ~/.tmux/scripts/popup.sh by tmux/configure.sh.
if [ "$(tmux display-message -p '#{session_name}')" = popup ]; then
  tmux detach-client
  exit 0
fi
# Inside a popup $TMUX is set, which makes tmux refuse to attach ("nested"): unset it and
# talk to this same server through its socket (the part of $TMUX before the first comma).
socket=${TMUX%%,*}
tmux display-popup -d '#{pane_current_path}' -w 80% -h 80% -E \
  "env -u TMUX tmux -S '$socket' new-session -A -s popup"
