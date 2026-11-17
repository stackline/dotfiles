#!/bin/bash

# Notify that a Claude Code session needs attention: ring the bell of this tmux pane and
# post a macOS notification.
# usage: notify.sh <status>   (the hook JSON is read from stdin)
#   title: "Claude Code: <status>", body: the session name
# Meant to be called from the Stop and Notification hooks in ~/.claude/settings.json.
#
# macOS attributes osascript notifications to Script Editor. To keep them on screen until
# dismissed, set System Settings > Notifications > Application Notifications > Script Editor >
# Alert Style from Temporary to Persistent. This applies to every osascript notification.

status=$1
transcript_path=$(jq -r '.transcript_path // empty')

# The hook input has no session name, so read it from the transcript the way the status line
# does (`session_name`): the latest `custom-title` (/rename), else the latest `ai-title`
# (generated). ripgrep scans the whole file fast, so the order of the entries does not matter.
name=""
if [ -f "$transcript_path" ]; then
  name=$(rg --no-config -a -N --no-filename '^\{"type":"(custom-title|ai-title)"' "$transcript_path" 2>/dev/null \
    | jq -rs '((map(select(.type == "custom-title")) | last) // (map(select(.type == "ai-title")) | last)) | .customTitle // .aiTitle // empty' 2>/dev/null)
fi

# Make tmux flag the window of this pane. The flag is cleared when the window is selected.
if [ -n "$TMUX_PANE" ]; then
  pane_tty=$(tmux display-message -p -t "$TMUX_PANE" '#{pane_tty}' 2>/dev/null)
  [ -z "$pane_tty" ] || { printf '\a' > "$pane_tty"; } 2>/dev/null
fi

# Pass the text as arguments so quotes in it cannot break the AppleScript.
osascript \
  -e 'on run argv' \
  -e 'display notification (item 2 of argv) with title (item 1 of argv) sound name "Glass"' \
  -e 'end run' \
  "Claude Code: ${status}" "$name"
