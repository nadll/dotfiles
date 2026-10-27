# ---- thefuck -----
# Programmatically correct mistyped console commands. https://github.com/nvbn/thefuck
# `thefuck --alias` starts Python, which slows down every new shell;
# define placeholders that load the real `fuck`/`fk` functions on first use instead
if command -v thefuck >/dev/null; then
  _thefuck_load() {
    unfunction fuck fk 2>/dev/null
    eval "$(thefuck --alias)"
    eval "$(thefuck --alias fk)"
  }
  fuck() { _thefuck_load && fuck "$@"; }
  fk() { _thefuck_load && fk "$@"; }
fi
