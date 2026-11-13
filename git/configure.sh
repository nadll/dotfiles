# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

# A real ~/.gitconfig from before the dotfiles is moved to a backup by `link` below.
# Copy its identity and signing key settings (user.*, gpg.*) to ~/.gitconfig.local first, so they
# keep working; settings already in ~/.gitconfig.local win. (commit/tag.gpgsign are on in git/.gitconfig)
if [ -f "$HOME/.gitconfig" ] && [ ! -L "$HOME/.gitconfig" ]; then
  git config --file "$HOME/.gitconfig" --get-regexp '^(user\.|gpg\.)' 2>/dev/null |
    while read -r key value; do
      if ! git config --file "$HOME/.gitconfig.local" --get "$key" >/dev/null 2>&1; then
        info "Copying $key from your old ~/.gitconfig to ~/.gitconfig.local"
        run git config --file "$HOME/.gitconfig.local" "$key" "$value"
      fi
    done
fi

link "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
link "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore"
link "$DOTFILES/git/git.rc.sh" "$SHELLRCDIR/"
