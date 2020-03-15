#!/bin/bash
#
# Change directory to specific repository
# ref. https://weblog.bulknews.net/ghq-peco-percol-b6be7828dc1b

function go_to_repository() {
  local selected_dir
  selected_dir=$(ghq list --full-path | fzf --reverse)

  if [ -d "$selected_dir" ]; then
    cd "$selected_dir"
  fi
}
