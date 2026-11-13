#!/bin/sh
# Status bar "SW" widget (used in status-right in tmux.conf): runs the tmux-plugin-sysstat swap
# script, and shows SW:0% when it prints nothing. On macOS there is no swap until memory runs
# short, and the plugin then divides by zero (macOS awk aborts) and outputs nothing.
# Prints nothing if the plugin isn't installed (prefix+I / tpm/bin/install_plugins).
# Linked to ~/.tmux/scripts/swap.sh by tmux/configure.sh.
plugins=${TMUX_PLUGIN_MANAGER_PATH:-$HOME/.tmux/plugins/}
script=${plugins%/}/tmux-plugin-sysstat/scripts/swap.sh
[ -x "$script" ] || exit 0
out=$("$script" 2>/dev/null)
if [ -n "$out" ]; then
  printf '%s\n' "$out"
else
  # same colour the plugin uses for low usage (@sysstat_swap_color_low in tmux.conf)
  color=$(tmux show-option -gqv @sysstat_swap_color_low 2>/dev/null)
  printf 'SW:#[fg=%s]0%%#[default]\n' "${color:-green}"
fi
