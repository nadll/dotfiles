#!/usr/bin/env bash
# Bootstrap a new Mac: Homebrew, packages (brew/Brewfile), oh-my-zsh, then every <tool>/configure.sh
# Safe to re-run: existing real files are backed up, symlinks are refreshed.
#
# Usage: ./install.sh [--dry-run] [--skip-brew] [--macos] [--pro]
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES

export ZDOTDIR="$HOME/.config/zsh"
export SHELLENVDIR="$ZDOTDIR/.env"
export SHELLRCDIR="$ZDOTDIR/.rc"

DRY_RUN=0
SKIP_BREW=0
MACOS_PREFS=0
PRO=0

usage() {
  sed -n '2,5p' "$0" | sed 's/^# \{0,1\}//'
}

while [ $# -gt 0 ]; do
  case "$1" in
    -n|--dry-run) DRY_RUN=1 ;;
    --skip-brew) SKIP_BREW=1 ;;
    --macos) MACOS_PREFS=1 ;;
    --pro) PRO=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
  shift
done

# =====================
# Helpers, also used by <tool>/configure.sh
# =====================

info() { printf '\033[1;34m-----> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m-----> %s\033[0m\n' "$*" >&2; }

# Run a command, or only print it in dry-run mode
run() {
  if [ "$DRY_RUN" = 1 ]; then
    printf '[dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

# Shorten paths in messages: $DOTFILES/... and ~/...
pretty() {
  local p=${1/#$DOTFILES/\$DOTFILES}
  printf '%s' "${p/#$HOME/\~}"
}

# Move a real file (not a symlink) out of the way before replacing it
backup() {
  local target=$1
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local dest
    dest="$target.backup.$(date +%Y%m%d%H%M%S)"
    info "Moving your old $(pretty "$target") to $(pretty "$dest")"
    run mv "$target" "$dest"
  fi
}

# link <source> <target>
# A <target> ending with "/" is a directory: link into it under the source's name
link() {
  local src=$1 target=$2
  case "$target" in
    */) target="$target$(basename "$src")" ;;
  esac
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$src" ]; then
    return
  fi
  if [ ! -e "$src" ] && [ "$DRY_RUN" = 0 ]; then
    warn "Skipping missing $(pretty "$src")"
    return
  fi
  backup "$target"
  info "Linking $(pretty "$target") -> $(pretty "$src")"
  if [ "$DRY_RUN" = 0 ]; then
    mkdir -p "$(dirname "$target")"
    ln -sfn "$src" "$target"
  fi
}

# write_file <target> <content>
write_file() {
  local target=$1 content=$2
  info "Writing $(pretty "$target")"
  if [ "$DRY_RUN" = 0 ]; then
    mkdir -p "$(dirname "$target")"
    printf '%s\n' "$content" > "$target"
  fi
}

# clone_or_update <repo-url> <dir>
clone_or_update() {
  local url=$1 dir=$2
  if [ -d "$dir/.git" ]; then
    info "Updating $(basename "$dir")"
    run git -C "$dir" pull --ff-only --quiet
  else
    info "Cloning $(basename "$dir")"
    run git clone --depth 1 --quiet "$url" "$dir"
  fi
}

if [ "$(uname)" != "Darwin" ]; then
  warn "This installer targets macOS; non-macOS steps may fail."
fi

# =====================
# Homebrew
# =====================

load_brew() {
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

load_brew
if [ "$SKIP_BREW" = 0 ]; then
  if ! command -v brew >/dev/null 2>&1; then
    info "Installing Homebrew"
    if [ "$DRY_RUN" = 1 ]; then
      echo "[dry-run] install Homebrew from https://brew.sh"
    else
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      load_brew
    fi
  fi

  info "Installing packages from brew/Brewfile"
  run brew bundle --file="$DOTFILES/brew/Brewfile"

fi

# Pro packages (brew/Brewfile.pro) only on machines that opted in with --pro,
# remembered by ~/.dotfiles-pro so later runs and dotfiles-update install them too
if [ "$PRO" = 1 ] && [ ! -f "$HOME/.dotfiles-pro" ]; then
  info "Marking this machine as a pro machine (~/.dotfiles-pro)"
  run touch "$HOME/.dotfiles-pro"
fi
if [ "$SKIP_BREW" = 0 ] && { [ "$PRO" = 1 ] || [ -f "$HOME/.dotfiles-pro" ]; }; then
  info "Installing packages from brew/Brewfile.pro"
  run brew bundle --file="$DOTFILES/brew/Brewfile.pro"
fi

# =====================
# oh-my-zsh, theme & plugins
# =====================

export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM_DIR="$ZSH/custom"
ZSH_PLUGINS_DIR="$ZSH_CUSTOM_DIR/plugins"

if [ ! -d "$ZSH" ]; then
  info "Installing oh-my-zsh"
  if [ "$DRY_RUN" = 1 ]; then
    echo "[dry-run] install oh-my-zsh into $ZSH"
  else
    # --unattended: don't change the login shell, don't start zsh; KEEP_ZSHRC: never touch our .zshrc
    KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
fi

echo "-----> Installing/updating zsh theme 'powerlevel10k'..."
clone_or_update https://github.com/romkatv/powerlevel10k "$ZSH_CUSTOM_DIR/themes/powerlevel10k"
echo "-----> Installing/updating zsh plugin 'zsh-autosuggestions'..."
clone_or_update https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
echo "-----> Installing/updating zsh plugin 'zsh-syntax-highlighting'..."
clone_or_update https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"

# =====================
# Tools not available in Homebrew
# =====================

# Interactive `git` with the help of `fzf` https://github.com/bigH/git-fuzzy
clone_or_update https://github.com/bigH/git-fuzzy "$DOTFILES/vendor/git-fuzzy"
link "$DOTFILES/vendor/git-fuzzy/bin/git-fuzzy" "$HOME/bin/git-fuzzy"

# Git object pickers for fzf https://github.com/junegunn/fzf-git.sh, sourced by fzf/fzf.rc.sh
clone_or_update https://github.com/junegunn/fzf-git.sh "$DOTFILES/vendor/fzf-git.sh"

# =====================
# Per-tool configuration
# =====================

configure() {
  local tool=$1
  info "Configuring $tool"
  # subshell: a script that fails or changes directory can't affect the others
  # shellcheck source=/dev/null
  ( . "$DOTFILES/$tool/configure.sh" )
}

# shell first: it creates $ZDOTDIR and the .env/.rc directories the others link into
configure shell

# Record where the repo lives so shell config can find it at runtime
write_file "$SHELLENVDIR/00-dotfiles.env.sh" "export DOTFILES=\"$DOTFILES\""

for script in "$DOTFILES"/*/configure.sh; do
  tool="$(basename "$(dirname "$script")")"
  case "$tool" in
    shell) continue ;;
    macos|iterm2) [ "$(uname)" = "Darwin" ] || continue ;;
  esac
  configure "$tool"
done

# =====================
# macOS preferences, only with --macos
# =====================

if [ "$MACOS_PREFS" = 1 ]; then
  if [ "$(uname)" != "Darwin" ]; then
    warn "--macos: not on macOS, skipping macos/preferences.sh"
  elif [ "$DRY_RUN" = 1 ]; then
    echo "[dry-run] sh $DOTFILES/macos/preferences.sh (after asking for confirmation)"
  else
    warn "macos/preferences.sh changes system settings, including turning off Gatekeeper and"
    warn "download quarantine, and sets the time zone to Europe/Kiev and the locale to en_UA."
    printf 'Apply macOS preferences now? [y/N] '
    read -r answer || answer=""
    case "$answer" in
      [yY]*) info "Applying macOS preferences"; sh "$DOTFILES/macos/preferences.sh" ;;
      *) info "Skipped macos/preferences.sh" ;;
    esac
  fi
fi

# =====================
# Login shell
# =====================

case "${SHELL:-}" in
  */zsh) ;;
  *)
    info "Making zsh your login shell"
    run chsh -s /bin/zsh
    ;;
esac

echo
info "👌 Done. Next steps:"
echo "  1. Open a new terminal (or run: exec zsh)"
echo "  2. Set your git identity: $DOTFILES/git_setup.sh"
