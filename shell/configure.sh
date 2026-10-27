# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $ZDOTDIR, $SHELLRCDIR, $SHELLENVDIR)

# specify custom location for zsh configuration files via ZDOTDIR variable
# set in ~/.zshenv (no sudo needed); the PATH ordering fix for macOS path_helper lives in .zprofile
link "$DOTFILES/shell/zsh/home.zshenv" "$HOME/.zshenv"

# earlier versions of this repo wrote ZDOTDIR and a path_helper block into /etc/zshenv (with sudo)
if grep -qs -E 'ZDOTDIR|path_helper' /etc/zshenv; then
  warn "/etc/zshenv still has lines from the old setup (ZDOTDIR, path_helper). They're harmless;"
  warn "remove them with: sudo \$EDITOR /etc/zshenv"
fi

run mkdir -p "$SHELLENVDIR" "$SHELLRCDIR"
link "$DOTFILES/shell/zsh/.zshenv" "$ZDOTDIR/.zshenv"
link "$DOTFILES/shell/zsh/.zprofile" "$ZDOTDIR/.zprofile"
link "$DOTFILES/shell/zsh/.zshrc" "$ZDOTDIR/.zshrc"
link "$DOTFILES/shell/.inputrc" "$HOME/.inputrc"

# zsh now reads everything from $ZDOTDIR: carry over history and powerlevel10k config from $HOME once
for file in .zsh_history .p10k.zsh; do
  if [ -f "$HOME/$file" ] && [ ! -e "$ZDOTDIR/$file" ]; then
    info "Copying ~/$file to $(pretty "$ZDOTDIR/$file")"
    run cp "$HOME/$file" "$ZDOTDIR/$file"
  fi
done

# disable "Last Login" prompt when terminal starts new login shell
# macos - Remove "Last login" message for new tabs in terminal - Stack Overflow https://stackoverflow.com/questions/15769615/remove-last-login-message-for-new-tabs-in-terminal
run touch "$HOME/.hushlogin"

# symlink executable scripts that should be on PATH to $HOME/bin
for script in "$DOTFILES"/shell/bin/*; do
  [ -e "$script" ] || continue
  link "$script" "$HOME/bin/$(basename "$script")"
done

# symlink alias and functions to be sourced at shell startup
link "$DOTFILES/shell/alias.sh" "$SHELLRCDIR/shell-alias.rc.sh"
link "$DOTFILES/shell/functions.sh" "$SHELLRCDIR/shell-functions.rc.sh"
