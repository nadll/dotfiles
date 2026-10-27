# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

link "$DOTFILES/code/code.rc.sh" "$SHELLRCDIR/"

# Symlink VS Code settings and keybindings to the present `settings.json` and `keybindings.json` files
# If it's a macOS
if [ "$(uname)" = "Darwin" ]; then
  CODE_PATH="$HOME/Library/Application Support/Code/User"
# Else, it's a Linux
else
  CODE_PATH="$HOME/.config/Code/User"
  # If this folder doesn't exist, it's a WSL
  if [ ! -e "$CODE_PATH" ]; then
    CODE_PATH="$HOME/.vscode-server/data/Machine"
  fi
fi

for name in settings.json keybindings.json; do
  link "$DOTFILES/code/$name" "$CODE_PATH/$name"
done
