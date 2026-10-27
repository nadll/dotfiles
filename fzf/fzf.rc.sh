# TODO: use universal file preview

# 'junegunn/fzf', command line fuzzy finder
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard 2>/dev/null || fd --type f --type l $FD_OPTIONS"
export FZF_DEFAULT_OPTS="\
  --no-mouse \
  --height 80% \
  --cycle \
  --no-scrollbar \
  --border=none \
  --marker=+ \
  --reverse \
  --multi \
  --info=inline \
  --preview='if [ -d {} ]; then tree -C -L 2 {}; elif [ -f {} ]; then bat -f --style=numbers {}; fi' \
  --preview-window='right:60%:wrap,<50(bottom,50%)' \
  --history='$HOME/.fzf_history' --history-size=50 \
  --bind='f3:execute(bat --style=numbers {} || less -f {})' \
  --bind='f4:execute($EDITOR {})' \
  --bind='alt-w:toggle-preview-wrap' \
  --bind='ctrl-d:half-page-down' \
  --bind='ctrl-u:half-page-up' \
  --bind='ctrl-x:execute(rm -i {+})+abort' \
  --bind='ctrl-l:clear-query+first' \
  --bind='ctrl-y:execute-silent(echo {+} | pbcopy)+abort' \
  --bind='ctrl-\:change-preview-window(hidden|bottom,50%|right:60%)'"

# CTRL-T - Paste the selected files and directories onto the command-line
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview='if [ -d {} ]; then tree -C -L 2 {}; elif [ -f {} ]; then bat -f --style=numbers {}; fi'"

# CTRL-R - Paste the selected command from history onto the command-line
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --height 60%
  --preview-window='bottom:3:wrap:border-top,<50(bottom:3:wrap:border-top)'
  --with-nth '2..'
  --preview 'echo {2..}'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --bind 'change:first'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Override built-in 'cd' shell command to show all subdirs in fzf if called without args (like ALT+C does)
# Alt-C, cd into the selected directory
# export FZF_ALT_C_OPTS="--preview 'tree -C -L 2 {}'"
# export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
cd() {
  if [ $# -gt 0 ]; then
    builtin cd "$@" || return;
    return;
  fi

  selected_dir=$(fd --type d $FD_OPTIONS | fzf \
    --no-multi \
    --height 60% \
    --preview 'tree -C -L 2 {}')

  if [ -n "$selected_dir" ]; then
    cd "$selected_dir" || return;
  fi
}

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# for fzf '**' shell completions (vim **<Tab>)
# - The first argument to the function ($1) is the base path to start traversal
_fzf_compgen_path() {
  fd . "$1"
}

# Use fd to generate the list for directory completion (cd **<Tab>)
_fzf_compgen_dir() {
  fd --type d . "$1"
}

# ============================================================
# Merged from the old root zshrc (lewagon-based setup)
# Settings that conflict with the ones above are kept commented out
# and marked "(old zshrc, overridden above)"; pick one and delete the other.
# ============================================================

# ---- FZF -----

# (old zshrc, overridden above)
# export FZF_DEFAULT_OPTS="--no-mouse --height 50% --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"

# -- Use fd instead of fzf --

# (old zshrc, overridden by fd/fd.rc.sh)
# FD_OPTIONS="--follow --exclude .git --exclude node_modules"

# (old zshrc, overridden above)
# export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l $FD_OPTIONS"
# export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
# (old zshrc, overridden above)
# _fzf_compgen_path() {
#   fd --hidden --exclude .git . "$1"
# }

# Use fd to generate the list for directory completion
# (old zshrc, overridden above)
# _fzf_compgen_dir() {
#   fd --type=d --hidden --exclude .git . "$1"
# }

# ---- FZF Git -----

# https://github.com/junegunn/fzf-git.sh
[ -f "$DOTFILES/vendor/fzf-git.sh/fzf-git.sh" ] && source "$DOTFILES/vendor/fzf-git.sh/fzf-git.sh"

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

# ---- FZF Preview -----

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

# (old zshrc, overridden above)
# export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# Enable fuzzy search key bindings and auto completion
# Set up fzf key bindings and fuzzy completion
command -v fzf >/dev/null && eval "$(fzf --zsh)"

# legacy: ~/.fzf.zsh was generated by $(brew --prefix)/opt/fzf/install, replaced by `fzf --zsh` above
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
