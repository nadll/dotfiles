#!/usr/bin/env bash
# Report aliases and functions defined more than once across the shell config.
# The .rc files load in alphabetical order, so a later definition silently wins.
#
# Usage: .github/scripts/check-duplicates.sh   (exit 1 if any duplicate is found)
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

files=(shell/zsh/.zshrc */*.rc.sh shell/alias.sh shell/functions.sh git/funcs.sh)

# known duplicates, kept on purpose
allowed=(
  cd # fzf/fzf.rc.sh cd() is kept unchanged; `alias cd="z"` (zoxide) in shell/alias.sh wins
)

# print "<kind> <name> <file>:<line>" for every alias and function definition
definitions() {
  grep -nE '^[[:space:]]*(alias([[:space:]]+--)?[[:space:]]+[^=[:space:]]+=|function[[:space:]]+[A-Za-z_][A-Za-z0-9_-]*|[A-Za-z_][A-Za-z0-9_-]*[[:space:]]*\(\))' "${files[@]}" |
    while IFS=: read -r file line text; do
      text="${text#"${text%%[![:space:]]*}"}"
      case "$text" in
        alias*)
          name="${text#alias}"; name="${name# }"; name="${name#-- }"; name="${name%%=*}"
          echo "alias $name $file:$line" ;;
        function*)
          name="${text#function}"; name="${name# }"; name="${name%%[ (]*}"
          echo "function $name $file:$line" ;;
        *)
          echo "function ${text%%[ (]*} $file:$line" ;;
      esac
    done
}

dupes=$(definitions | grep -v -E "^[a-z]+ ($(IFS='|'; echo "${allowed[*]}")) " | awk '{ seen[$2] = seen[$2] "\n  " $1 " in " $3; n[$2]++ } END { for (k in n) if (n[k] > 1) printf "%s:%s\n", k, seen[k] }')

if [ -n "$dupes" ]; then
  echo "Defined more than once (the last one loaded wins):"
  echo "$dupes"
  exit 1
fi
echo "No duplicate aliases or functions."
