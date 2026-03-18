#!/bin/bash

# Reorder PATH entries so system default paths come last, and remove duplicates.
# Implemented as a pure bash function to avoid spawning an external process.
function dietpath() {
  local -a default_paths=(
    "/usr/local/bin"
    "/usr/local/sbin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
    "/Library/Apple/usr/bin"
  )
  local -a current_paths low_priorities=() high_priorities=()
  local p cp lp hp is_low already

  IFS=':' read -ra current_paths <<< "$PATH"

  # Collect system default paths present in current PATH (low priority)
  for p in "${default_paths[@]}"; do
    for cp in "${current_paths[@]}"; do
      [[ "$p" == "$cp" ]] && { low_priorities+=("$p"); break; }
    done
  done

  # Collect remaining paths, deduplicated (high priority)
  for cp in "${current_paths[@]}"; do
    is_low=false
    for lp in "${low_priorities[@]}"; do
      [[ "$cp" == "$lp" ]] && { is_low=true; break; }
    done
    $is_low && continue

    already=false
    for hp in "${high_priorities[@]}"; do
      [[ "$cp" == "$hp" ]] && { already=true; break; }
    done
    $already && continue

    high_priorities+=("$cp")
  done

  local -a result=("${high_priorities[@]}" "${low_priorities[@]}")
  local IFS=':'
  echo "${result[*]}"
}

function dietpath_wrapper() {
  dietpath
}
