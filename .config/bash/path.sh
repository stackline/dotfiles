#!/bin/bash

# TODO: Remove this function if unnecessary.
function remove_path_entry() {
  local readonly target="$1"
  local new_path

  for entry in $(echo "$PATH" | tr ':' '\n')
  do
    if [ "$entry" = "$target" ]; then
      continue;
    fi

    if [ "$new_path" = "" ]; then
      new_path="$entry"
    else
      new_path="$new_path:$entry"
    fi
  done

  export PATH="$new_path"
}

function remove_duplicate_path_entries() {
  local readonly old_entries
  old_entries=$(echo "$PATH" | tr ':' '\n')
  local new_entries=()

  for old_entry in $old_entries
  do
    existing=false
    for new_entry in "${new_entries[@]}"
    do
      if [ "$old_entry" = "$new_entry" ]; then
        existing=true
      fi
    done

    if [ $existing = false ]; then
      new_entries+=("$old_entry");
    fi
  done

  local new_path
  for new_entry in "${new_entries[@]}"
  do
    if [ "$new_path" = "" ]; then
      new_path="$new_entry"
    else
      new_path="$new_path:$new_entry"
    fi
  done
  export PATH="$new_path"
}
