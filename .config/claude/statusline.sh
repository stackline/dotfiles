#!/bin/bash

# trouble shooting
#   chmod +x
#   chmod 744 ~/.claude/statusline.sh

# Read JSON input from stdin
input=$(cat)

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
  (.workspace.current_dir // .cwd // "."),
  (.context_window.context_window_size // 1000000 | tostring),
  (.context_window.current_usage.input_tokens // 0 | tostring),
  (.context_window.current_usage.output_tokens // 0 | tostring),
  (.context_window.current_usage.cache_creation_input_tokens // 0 | tostring),
  (.context_window.current_usage.cache_read_input_tokens // 0 | tostring),
  (.context_window.used_percentage // 0 | tostring),
  (.cost.total_cost_usd // 0 | tostring),
  (.rate_limits.five_hour.used_percentage // "null"),
  (.rate_limits.seven_day.used_percentage // "null")
' <<< "$input")

model_name="${vals[0]}"
cwd="${vals[1]}"
context_window_size="${vals[2]}"
current_input="${vals[3]}"
current_output="${vals[4]}"
current_cache_creation="${vals[5]}"
current_cache_read="${vals[6]}"
used_percentage="${vals[7]}"
cost_usd="${vals[8]}"
rate_5h="${vals[9]}"
rate_7d="${vals[10]}"

repo_name="${cwd##*/}"  # ##*/ strips everything up to and including the last slash

# Branch: omitted for brevity (re-enable by uncommenting; adds ~2ms git subprocess)
# git_branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
# [ -n "$git_branch" ] && repo_name="$repo_name ($git_branch)"

# Context total
current_total=$((current_input + current_output + current_cache_creation + current_cache_read))

# Format tokens as K (bash integer division, no subprocess)
current_display="$(( current_total / 1000 ))K"
window_display="$(( context_window_size / 1000 ))K"

# Cost (USD, 2 decimal places)
cost_usd_disp=$(awk "BEGIN {printf \"%.2f\", $cost_usd}")

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

printf "%s @ %s | %s/%s %s | \$%s%s" \
  "$model_name" "$repo_name" "$current_display" "$window_display" \
  "$ctx_str" "$cost_usd_disp" "$rate_str"
