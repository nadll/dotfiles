# $DOTFILES (repo location) is set by $ZDOTDIR/.env/00-dotfiles.env.sh, written by install.sh

# keep PATH/MANPATH entries unique, so this file can be re-sourced (see .zprofile)
# (the scalar names too: PATH="..." assignments are only deduplicated with -U on PATH itself)
typeset -U path PATH manpath MANPATH

export PAGER="less"
# VS Code; vim config (vim/) stays installed as a fallback
export EDITOR="code"

# preferred over $EDITOR by some tools
export VISUAL="code"

export PATH="$PATH:$HOME/bin"
export PATH="$HOME/.local/bin:$PATH"

# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:$HOME/.docker/bin"
# End of Docker Desktop section.

# Locale
# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# source all extra env files
export SHELLENVDIR="$ZDOTDIR/.env"
for envFile in "$SHELLENVDIR"/*(N); do
  source "$envFile"
done
