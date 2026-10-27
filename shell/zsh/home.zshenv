# Linked to ~/.zshenv by shell/configure.sh
# The only zsh file kept in $HOME: point zsh at ~/.config/zsh for everything else
# (replaces writing ZDOTDIR into /etc/zshenv, which needed sudo)
export ZDOTDIR="$HOME/.config/zsh"

# zsh has already picked ~/.zshenv, so load $ZDOTDIR/.zshenv by hand;
# .zprofile and .zshrc are then read from $ZDOTDIR automatically
[ -f "$ZDOTDIR/.zshenv" ] && source "$ZDOTDIR/.zshenv"
