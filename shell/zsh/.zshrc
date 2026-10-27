# Profile shell startup: ZPROF=1 zsh -i -c exit (report printed at the end of this file)
[[ -n "$ZPROF" ]] && zmodload zsh/zprof

# Disable XON/XOFF flow control to free up <C-s> and <C-q> shortcuts in terminal
# By default <C-s> and <C-q> pause and resume the terminal output,
# but we might use them in a Vim or somewhere else, so let's unbind them
# NOTE: do this only for interactive shell, and before the instant prompt below:
# after it stdin is no longer the terminal, so stty fails with "Operation not supported by device"
[[ $- == *i* ]] && stty -ixon

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/zshrc.pre.zsh"

# Disable bracketed-paste-magic, url-quote-magic and whatever-magic plugins
# NOTE: should be run before sourcing oh-my-zsh
# See: https://github.com/ohmyzsh/ohmyzsh/issues/5569
export DISABLE_MAGIC_FUNCTIONS="true"

# Change default command line prompt symbol
# see https://github.com/sindresorhus/pure
export PURE_PROMPT_SYMBOL=">"

# https://github.com/sindresorhus/pure
# the max execution time of a process before its run time is shown when it exits
export PURE_CMD_MAX_EXEC_TIME=0

# configure zsh history behavior
export SAVEHIST=10000
export HISTSIZE=10000
export HISTFILE="${ZDOTDIR}/.zsh_history"
export HISTCONTROL=ignorespace:ignoredups

# disable timeout for ESC keypress
export KEYTIMEOUT=1

# increase "docker" client  and "docker-compose" client timeouts from 60s to 120s
export DOCKER_CLIENT_TIMEOUT=120
export COMPOSE_HTTP_TIMEOUT=120

# ==================
# oh-my-zsh
# loaded before the options and key bindings below, so those override its defaults
# ==================
ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one from https://github.com/robbyrussell/oh-my-zsh/wiki/themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Useful oh-my-zsh plugins
plugins=(git gitfast last-working-dir common-aliases zsh-autosuggestions zsh-syntax-highlighting history-substring-search web-search)

# Disable warning about insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)

# machine-local aliases and functions, not tracked in this repo
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"
[[ -f "$HOME/.functions" ]] && source "$HOME/.functions"

zstyle ':autocomplete:tab:*' insert-unambiguous yes
zstyle ':autocomplete:tab:*' widget-style menu-select
zstyle ':autocomplete:*' recent-dirs z.sh

# fast man page access with <esc-h>
autoload run-help

# compatibility with bash
setopt shwordsplit
setopt nobeep

# Automatically cd when command is unknown or can't be executed but recognized as a valid directory
# Basically it means you can omit cd when doing "cd /some/dir"
setopt auto_cd

# so equals test works [ "$1" == "value" ]
# see http://www.zsh.org/mla/users/2011/msg00161.html
unsetopt equals

# TODO: report non-zero exit status in terminal somehow

# Define how zsh handles escape sequences produced by terminal emulator
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line

# Hook up zsh-users/zsh-history-substring-search
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# set Zsh autocompletion menu behavior
# display the completion menu after two use of the TAB key.
# don't select the first match given by the completion menu
# automatically list choices on ambiguous completion.
setopt AUTO_MENU
unsetopt MENU_COMPLETE
setopt AUTO_LIST

# Enter completion menu with <Tab>, navigate around within a menu with <Tab>
# bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# search inside completion
bindkey -M menuselect '/' history-incremental-search-forward
bindkey -M menuselect '?' history-incremental-search-backward

# close completion on ESC
bindkey -M menuselect '^[' undo

zstyle ':completion:*' menu select

# Load "pyenv" shell helper
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi

# copy the active line from the command line buffer
# onto the system clipboard
# borrowed from https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/copybuffer/copybuffer.plugin.zsh
copycmdline () {
  printf "%s" "$BUFFER" | pbcopy
}
zle -N copycmdline
bindkey "^O" copycmdline

# show every new command on the top of the screen
# borrowed from https://github.com/Valiev/almostontop/blob/master/almostontop.plugin.zsh
# Valiev/almostontop uses "zle redisplay", but it resets the whole scrollback buffer
function _accept_line_almostontop {
  zle clear-screen
  zle .accept-line
}
zle -N accept-line _accept_line_almostontop

# shell command completion for gcloud.
# export PATH="$PATH:/usr/local/google-cloud-sdk/bin"
# if [ -f '/usr/local/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/local/google-cloud-sdk/completion.zsh.inc'; fi

# source all extra rc files
export SHELLRCDIR="$ZDOTDIR/.rc"
for rcFile in "$SHELLRCDIR"/*(N); do
  source "$rcFile"
done

# use LS_COLORS colors in tab completion for files and directories
# (after the .rc files, so it picks up LS_COLORS from coreutils/coreutils.rc.sh)
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# with ZDOTDIR set, `p10k configure` writes to $ZDOTDIR/.p10k.zsh
[[ ! -f ${ZDOTDIR:-~}/.p10k.zsh ]] || source ${ZDOTDIR:-~}/.p10k.zsh

[[ -n "$ZPROF" ]] && zprof
