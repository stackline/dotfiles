#!/bin/bash

# trouble shooting
#   chmod +x
#   chmod 744 ~/.claude/statusline.sh

# Read JSON input from stdin. The read builtin is used instead of cat
# because each spawned process costs about 7 ms per refresh.
IFS= read -r -d "" input

# Debug: dump JSON to file (enable to inspect rate_limits field names etc.)
# echo "$input" > /tmp/claude_statusline_debug.json

# Single jq call - one value per line (bash 3.2 compatible, no mapfile)
vals=()
while IFS= read -r line; do
  vals+=("$line")
done < <(jq -r '
  ((.model.display_name // "Unknown")
    | gsub("Claude "; "")
    | gsub(" \\(1M context\\)"; "[1m]")
    | gsub(" \\([^)]*\\)"; "")
    | ascii_downcase
    | gsub(" "; "")),
  (.effort.level // ""),
  (.workspace.current_dir // .cwd // "."),
  (.context_window.context_window_size // 1000000 | tostring),
  (.context_window.current_usage.input_tokens // 0 | tostring),
  (.context_window.current_usage.output_tokens // 0 | tostring),
  (.context_window.current_usage.cache_creation_input_tokens // 0 | tostring),
  (.context_window.current_usage.cache_read_input_tokens // 0 | tostring),
  (.context_window.used_percentage // 0 | tostring),
  (.rate_limits.five_hour.used_percentage // "null"),
  (.rate_limits.seven_day.used_percentage // "null"),
  (.session_name // "" | gsub("[\n\r]"; " ")
    | if length > 28 then .[0:28] + "…" else . end),
  (.session_name // "" | gsub("[\n\r]"; " ")
    | if length > 20 then .[0:20] + "…" else . end),
  (.session_id // "")
' <<< "$input")

model_name="${vals[0]}"
effort_level="${vals[1]}"
cwd="${vals[2]}"
context_window_size="${vals[3]}"
current_input="${vals[4]}"
current_output="${vals[5]}"
current_cache_creation="${vals[6]}"
current_cache_read="${vals[7]}"
used_percentage="${vals[8]}"
rate_5h="${vals[9]}"
rate_7d="${vals[10]}"
session_title="${vals[11]}"
session_title_short="${vals[12]}"
session_id="${vals[13]}"

repo_name="${cwd##*/}"  # ##*/ strips everything up to and including the last slash

# Branch: omitted for brevity (re-enable by uncommenting; adds ~2ms git subprocess)
# git_branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
# [ -n "$git_branch" ] && repo_name="$repo_name ($git_branch)"

# Context total
current_total=$((current_input + current_output + current_cache_creation + current_cache_read))

# Token counts in the notation of Claude Desktop: 332k, 1M (bash integer division, no subprocess)
current_display="$(( current_total / 1000 ))k"
if (( context_window_size >= 1000000 && context_window_size % 1000000 == 0 )); then
  window_display="$(( context_window_size / 1000000 ))M"
else
  window_display="$(( context_window_size / 1000 ))k"
fi

used_int="${used_percentage%%.*}"
ctx_str="(${used_int}%)"

# Rate limits (show "?%" if unavailable e.g. startup or API key session)
if [ "$rate_5h" != "null" ]; then
  rate_5h_disp="${rate_5h%%.*}%"
else
  rate_5h_disp="?%"
fi
if [ "$rate_7d" != "null" ]; then
  rate_7d_disp="${rate_7d%%.*}%"
else
  rate_7d_disp="?%"
fi
rate_str=" | 5h:${rate_5h_disp}, 7d:${rate_7d_disp}"

# Session title (empty until Claude generates one, i.e. before the first turn)
if [ -n "$session_title" ]; then
  title_str="[${session_title}] "
else
  title_str=""
fi

# Rename the tmux window to the session title, so that a window list of
# several parallel Claude sessions is distinguishable at a glance.
# Set TMUX_RENAME=0 to disable. NOTE: rename-window turns off automatic-rename
# for that window; restore with `tmux set -w automatic-rename on`.
TMUX_RENAME="${TMUX_RENAME:-1}"
if [ "$TMUX_RENAME" = "1" ] && [ -n "$TMUX" ] && [ -n "$TMUX_PANE" ] && [ -n "$session_title_short" ]; then
  # Rename only when the title changed (avoids a tmux subprocess per refresh).
  # The session id is part of the cached value so that a different session
  # reusing the same pane id (e.g. after a tmux server restart) still renames.
  title_cache="${TMPDIR:-/tmp}/claude-tmux-title-${TMUX_PANE#%}"
  title_state="${session_id}	${session_title_short}"
  cached=""
  { IFS= read -r cached < "$title_cache"; } 2>/dev/null
  if [ "$cached" != "$title_state" ]; then
    printf '%s' "$title_state" > "$title_cache"
    tmux rename-window -t "$TMUX_PANE" "$session_title_short" 2>/dev/null
  fi
fi

printf "%s%s:%s @ %s | %s/%s %s%s" \
  "$title_str" \
  "$model_name" "$effort_level" "$repo_name" "$current_display" "$window_display" \
  "$ctx_str" "$rate_str"
