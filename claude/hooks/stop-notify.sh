#!/bin/sh
# Claude Code "Stop" hook: macOS notification and sound when Claude has finished answering.
# (The "Notification" hook in settings.json plays Glass when Claude is waiting for you instead.)
# Linked to ~/.claude/hooks/stop-notify.sh by claude/configure.sh.
# Claude Code passes the event as JSON on stdin; cwd is the project folder.
folder=$(jq -r '.cwd // empty' 2>/dev/null)
folder=${folder##*/}
# keep the AppleScript string valid
folder=$(printf '%s' "$folder" | tr -d '\042\134')
osascript -e "display notification \"Finished${folder:+ in $folder}\" with title \"Claude Code\"" >/dev/null 2>&1
afplay /System/Library/Sounds/Hero.aiff >/dev/null 2>&1 &
exit 0
