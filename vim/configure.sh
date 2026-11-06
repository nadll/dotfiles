# Sourced by install.sh (uses its link/run helpers and $DOTFILES, $SHELLRCDIR, $SHELLENVDIR)

if [ ! -f "$HOME/.vim/colors/solarized.vim" ]; then
   run mkdir -p "$HOME/.vim/colors"
   run curl -fL --retry 3 \
       https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim \
       -o "$HOME/.vim/colors/solarized.vim.tmp"
   run mv "$HOME/.vim/colors/solarized.vim.tmp" "$HOME/.vim/colors/solarized.vim"
fi

link "$DOTFILES/vim/.vimrc" "$HOME/.vimrc"
