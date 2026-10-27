# Put Homebrew on PATH and set HOMEBREW_PREFIX etc. (Apple Silicon or Intel)
# loaded from .zshenv, before coreutils.env.sh which relies on $HOMEBREW_PREFIX
if [ -n "${HOMEBREW_PREFIX:-}" ]; then
  # already set up (this file runs again from .zprofile, or the shell is nested):
  # skip the slower `brew shellenv` and only move Homebrew back in front of PATH
  export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
elif [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# (macOS-only) Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/docs/Analytics.md
export HOMEBREW_NO_ANALYTICS=1
