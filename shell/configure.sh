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
# powerlevel10k prompt config. `p10k configure` rewrites this file; afterwards check `git status`:
# if the link was replaced by a plain file, copy it to shell/zsh/.p10k.zsh and run install.sh again
link "$DOTFILES/shell/zsh/.p10k.zsh" "$ZDOTDIR/.p10k.zsh"
link "$DOTFILES/shell/.inputrc" "$HOME/.inputrc"

# zsh now reads everything from $ZDOTDIR: carry over history from $HOME once
# (the powerlevel10k config used to be copied here too, it's now linked from the repo above)
if [ -f "$HOME/.zsh_history" ] && [ ! -e "$ZDOTDIR/.zsh_history" ]; then
  info "Copying ~/.zsh_history to $(pretty "$ZDOTDIR/.zsh_history")"
  run cp "$HOME/.zsh_history" "$ZDOTDIR/.zsh_history"
fi

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
