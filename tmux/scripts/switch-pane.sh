#!/bin/sh
# Fuzzy-find any pane in any session and jump to it; bound to prefix + f in tmux.conf,
# which runs this script inside a popup. Shows "session / window  command  folder",
# with a preview of the pane's screen.
# Linked to ~/.tmux/scripts/switch-pane.sh by tmux/configure.sh.
line=$(tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}	#{session_name} / #{window_index}:#{window_name}  #{pane_current_command}  #{pane_current_path}' |
  fzf --delimiter='	' --with-nth=2 --prompt='pane> ' --reverse \
    --preview='tmux capture-pane -ep -t {1}' --preview-window=down,60%) || exit 0
tmux switch-client -t "${line%%	*}"
