#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# =====================
# Brew
# =====================
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  echo "brew not found after installation" >&2
  exit 1
fi

#sudo tee -a "/etc/zshenv" >/dev/null << EOF
#eval "\$(/opt/homebrew/bin/brew shellenv)"
#EOF

# ==================
# ZSH
# ==================
brew install zsh

# make just installed "zsh" binary a default shell
#echo "$(which zsh)" | sudo tee -a /etc/shells
echo "$(which zsh)"
#chsh -s "$(which zsh)"

# ==================
# ohmyzsh
# ==================
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh already installed, skipping."
fi

# Install zsh-syntax-highlighting plugin
CURRENT_DIR=`pwd`
ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$ZSH_PLUGINS_DIR" && cd "$ZSH_PLUGINS_DIR"

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
  echo "-----> Installing zsh plugin 'zsh-autosuggestions'..."
  git clone https://github.com/zsh-users/zsh-autosuggestions
fi

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  echo "-----> Installing zsh plugin 'zsh-syntax-highlighting'..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting
fi

cd "$CURRENT_DIR"

# =====================
# git
# =====================
brew install git

# ======================
#  Fonts
# ======================

brew install --cask font-meslo-lg-nerd-font
brew install --cask font-droid-sans-mono-for-powerline
brew install --cask font-droid-sans-mono-nerd-font

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
#brew install pyenv
#pyenv install 3.14.13
#pyenv global system

# GitHub - ranger/ranger: A VIM-inspired filemanager for the console https://github.com/ranger/ranger
#pip3 install ranger-fm
#ranger --copy-config=rifle

# =====================
# git friends
# =====================

# Diff tools
brew install --cask sourcetree

# A viewer for git and diff output
# https://github.com/dandavison/delta
# TODO: choose between side-by-side and inline based on viewport width
# 🚀 automatic side-by-side based on column width? · Issue #359 · dandavison/delta https://github.com/dandavison/delta/issues/359
brew install git-delta

# A simple terminal UI for git commands
brew install lazygit

# GitHub - bigH/git-fuzzy: interactive `git` with the help of `fzf` https://github.com/bigH/git-fuzzy
PREFIX=$(brew --prefix)
TARGET="$PREFIX/share/git-fuzzy"
mkdir -p "$PREFIX/share"
if [ ! -d "$TARGET" ]; then
  git clone https://github.com/bigH/git-fuzzy "$TARGET"
else
  echo "git-fuzzy already exists, updating..."
  git -C "$TARGET" pull
fi
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
brew install --cask docker

# ===============================
#  GUI apps from 'brew cask'
# ================================

# Video player
brew install --cask vlc

# Refresh the current terminal with the newly installed configuration
exec zsh

echo "👌 Carry on with git setup!"
