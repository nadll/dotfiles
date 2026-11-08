#!/usr/bin/env bash
# Claude Code status line, linked to ~/.claude/statusline.sh by claude/configure.sh.
# Claude Code passes session data as JSON on stdin; whatever this prints is shown under the prompt:
#   [Opus] 📁 dotfiles | 🌿 master* | ⏱️ 12m 5s
#   ███░░░░░░░ 34% | $1.27 | Prices are only referential
# Docs: https://code.claude.com/docs/en/statusline
export LC_NUMERIC=C

if ! command -v jq >/dev/null 2>&1; then
  echo "status line needs jq: brew install jq"
  exit 0
fi

input=$(cat)

# one jq call for all fields, separated by \x1f (a tab would merge empty fields)
IFS=$'\x1f' read -r MODEL CWD COST PCT DURATION_MS < <(jq -r '[
    (.model.display_name // "?"),
    (.workspace.current_dir // .cwd // ""),
    (.cost.total_cost_usd // 0),
    (.context_window.used_percentage // 0 | floor),
    (.cost.total_duration_ms // 0 | floor)
  ] | map(tostring) | join("\u001f")' <<<"$input")

CYAN=$'\e[36m' GREEN=$'\e[32m' YELLOW=$'\e[33m' RED=$'\e[31m' DIM=$'\e[2m' RESET=$'\e[0m'

# Context bar: green, yellow from 70%, red from 90% (time to start a fresh session)
if [ "$PCT" -ge 90 ]; then BAR_COLOR=$RED
elif [ "$PCT" -ge 70 ]; then BAR_COLOR=$YELLOW
else BAR_COLOR=$GREEN
fi
FILLED=$((PCT > 100 ? 10 : PCT / 10)); EMPTY=$((10 - FILLED))
printf -v FILL "%${FILLED}s"; printf -v PAD "%${EMPTY}s"
BAR="${FILL// /█}${PAD// /░}"

# Session duration
TOTAL_SECS=$((DURATION_MS / 1000))
HOURS=$((TOTAL_SECS / 3600)) MINS=$(((TOTAL_SECS % 3600) / 60)) SECS=$((TOTAL_SECS % 60))
if [ "$HOURS" -gt 0 ]; then DURATION="${HOURS}h ${MINS}m"; else DURATION="${MINS}m ${SECS}s"; fi

# Git branch (short commit id when detached), * when there are uncommitted changes
BRANCH=""
if [ -n "$CWD" ] && git -C "$CWD" rev-parse --git-dir >/dev/null 2>&1; then
  name=$(git -C "$CWD" branch --show-current 2>/dev/null)
  [ -z "$name" ] && name=$(git -C "$CWD" rev-parse --short HEAD 2>/dev/null)
  [ -n "$(git -C "$CWD" status --porcelain 2>/dev/null | head -1)" ] && name="$name*"
  BRANCH=" | 🌿 $name"
fi

# Cost is what the session would cost at API prices; on a Pro/Max plan it's only an estimate
COST_FMT=$(printf '$%.2f' "$COST")

# Line 1: model, folder name, branch, duration
FOLDER=""; [ -n "$CWD" ] && FOLDER=" 📁 ${CWD##*/}"
printf '%s\n' "${CYAN}[$MODEL]${RESET}${FOLDER}${BRANCH} | ⏱️ ${DURATION}"
# Line 2: context bar, cost, disclaimer
printf '%s\n' "${BAR_COLOR}${BAR}${RESET} ${PCT}% | ${YELLOW}${COST_FMT}${RESET} | ${DIM}Prices are only referential${RESET}"
