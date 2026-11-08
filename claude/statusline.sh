#!/usr/bin/env bash
# Claude Code status line, linked to ~/.claude/statusline.sh by claude/configure.sh.
# Claude Code passes session data as JSON on stdin; whatever this prints is shown under the prompt:
#   Opus · ~/Documents/project · main* · ctx 42%
# Needs jq (brew/Brewfile). Docs: https://code.claude.com/docs/en/statusline

input=$(cat)

model=$(jq -r '.model.display_name // "?"' <<<"$input")
dir=$(jq -r '.workspace.current_dir // .cwd // ""' <<<"$input")
pct=$(jq -r '.context_window.used_percentage // 0' <<<"$input" | cut -d. -f1)

dim=$'\e[2m' green=$'\e[32m' yellow=$'\e[33m' red=$'\e[31m' reset=$'\e[0m'

# context usage: green, yellow from 50%, red from 80% (time to start a fresh session)
if [ "$pct" -ge 80 ]; then color=$red
elif [ "$pct" -ge 50 ]; then color=$yellow
else color=$green
fi

# git branch, with * when there are uncommitted changes
branch=""
if git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$dir" branch --show-current 2>/dev/null)
  [ -z "$branch" ] && branch=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null)
  [ -n "$(git -C "$dir" status --porcelain 2>/dev/null | head -1)" ] && branch="$branch*"
fi

# show $HOME as ~ (a literal ~ in ${dir/#$HOME/~} would be expanded back to $HOME)
case "$dir" in "$HOME"*) dir="~${dir#"$HOME"}" ;; esac

line="$model ${dim}·${reset} $dir"
[ -n "$branch" ] && line="$line ${dim}·${reset} $branch"
line="$line ${dim}·${reset} ${color}ctx ${pct}%${reset}"
printf '%s\n' "$line"
