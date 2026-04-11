#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# =====================
# Brew
# =====================
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo tee -a "/etc/zshenv" >/dev/null << EOF
eval "\$(/opt/homebrew/bin/brew shellenv)"
EOF

# =====================
# git
# =====================
brew install git

# make just installed "zsh" binary a default shell
echo "$(which zsh)" | sudo tee -a /etc/shells
chsh -s "$(which zsh)"

# ======================
#  Fonts
# ======================

brew tap homebrew/cask-fonts
brew install font-droid-sans-mono font-droid-sans-mono-nerd-font
brew install font-meslo-lg-nerd-font

# =======================================
# GNU utils instead of MacOS equivalents
# =======================================

brew install coreutils findutils diffutils \
  gnu-indent gnu-sed ed gnu-tar gnutls grep \
  gnu-which gawk gzip watch wget

# Upgrade old tools on Mac
brew install bash less nano curl make

# =====================
#  Python
# =====================

brew install python
brew install pyenv
pyenv install 3.14.13
pyenv global system

# GitHub - ranger/ranger: A VIM-inspired filemanager for the console https://github.com/ranger/ranger
#pip3 install ranger-fm
#ranger --copy-config=rifle

# =====================
# git friends
# =====================

# Diff tools
brew cask install sourcetree

# A viewer for git and diff output
# https://github.com/dandavison/delta
# TODO: choose between side-by-side and inline based on viewport width
# 🚀 automatic side-by-side based on column width? · Issue #359 · dandavison/delta https://github.com/dandavison/delta/issues/359
brew install git-delta

# A simple terminal UI for git commands
brew install lazygit

# GitHub - bigH/git-fuzzy: interactive `git` with the help of `fzf` https://github.com/bigH/git-fuzzy
PREFIX=$(brew --prefix)
mkdir -p "$PREFIX/share"
git clone https://github.com/bigH/git-fuzzy "$PREFIX/share/git-fuzzy"
ln -sf "$PREFIX/share/git-fuzzy/bin/git-fuzzy" "$PREFIX/bin/git-fuzzy"

# =========================
#  Apps & utilities
# =========================

# GitHub - junegunn/fzf: A command-line fuzzy finder https://github.com/junegunn/fzf
brew install fzf
$(brew --prefix)/opt/fzf/install

# Modern, maintained replacement for ls. https://github.com/eza-community/eza
brew install eza

# Simple, fast and user-friendly alternative to find. https://github.com/sharkdp/fd
brew install fd

# Official tldr client written in Rust. https://tldr.sh/tlrc/
brew install tlrc

# Programmatically correct mistyped console commands. https://github.com/nvbn/thefuck
brew install thefuck

# Shell extension to navigate your filesystem faster. https://github.com/ajeetdsouza/zoxide
brew install zoxide

# Perl compatible regular expressions library. https://www.pcre.org/
brew install pcre

# antonmedv/fx: Command-line tool and terminal JSON viewer 🔥 - https://github.com/antonmedv/fx
brew install fx

# GitHub - sharkdp/bat: A cat(1) clone with wings. https://github.com/sharkdp/bat
brew install bat

# htop - an interactive process viewer https://htop.dev/
brew install htop

# ShellCheck – shell script analysis tool https://www.shellcheck.net/
# find bugs in your shell scripts
brew install shellcheck

# 7-Zip is a file archiver with a high compression ratio https://7-zip.org/
brew install sevenzip

# GitHub - imsnif/bandwhich: Terminal bandwidth utilization tool https://github.com/imsnif/bandwhich
brew install bandwhich

# Docker
brew cask install docker

# ===============================
#  GUI apps from 'brew cask'
# ================================

# Video player
#brew cask install vlc

# Define a function which rename a `target` file to `target.backup` if the file
# exists and if it's a 'real' file, ie not a symlink
backup() {
  target=$1
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      mv "$target" "$target.backup"
      echo "-----> Moved your old $target config file to $target.backup"
    fi
  fi
}

symlink() {
  file=$1
  link=$2
  if [ ! -e "$link" ]; then
    echo "-----> Symlinking your new $link"
    ln -s $file $link
  fi
}


# For all files `$name` in the present folder except `*.sh`, `README.md`, `settings.json`,
# and `config`, backup the target file located at `~/.$name` and symlink `$name` to `~/.$name`
for name in aliases gitconfig rspec zprofile zshrc fzf-git.sh; do
  if [ ! -d "$name" ]; then
    if [ "$name" = "fzf-git.sh" ]; then
      target="$HOME/fzf-git.sh"
    else
      target="$HOME/.$name"
    fi
    backup $target
    symlink $PWD/$name $target
  fi
done

# Install zsh-syntax-highlighting plugin
CURRENT_DIR=`pwd`
ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$ZSH_PLUGINS_DIR" && cd "$ZSH_PLUGINS_DIR"
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  echo "-----> Installing zsh plugin 'zsh-syntax-highlighting'..."
  git clone https://github.com/zsh-users/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting
fi
cd "$CURRENT_DIR"

# Symlink VS Code settings and keybindings to the present `settings.json` and `keybindings.json` files
# If it's a macOS
if [[ `uname` =~ "Darwin" ]]; then
  CODE_PATH=~/Library/Application\ Support/Code/User
# Else, it's a Linux
else
  CODE_PATH=~/.config/Code/User
  # If this folder doesn't exist, it's a WSL
  if [ ! -e $CODE_PATH ]; then
    CODE_PATH=~/.vscode-server/data/Machine
  fi
fi

for name in settings.json keybindings.json; do
  target="$CODE_PATH/$name"
  backup $target
  symlink $PWD/$name $target
done

# Symlink SSH config file to the present `config` file for macOS and add SSH passphrase to the keychain
#if [[ `uname` =~ "Darwin" ]]; then
#  target=~/.ssh/config
#  backup $target
#  symlink $PWD/config $target
#  ssh-add --apple-use-keychain ~/.ssh/id_ed25519
#fi

# Refresh the current terminal with the newly installed configuration
exec zsh

echo "👌 Carry on with git setup!"
