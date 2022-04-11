#!/bin/bash

function fzf_git_add() {
  # NOTE: How to execute git add only once by processing with perl and sed.
  #
  # selected=$(git status -s | fzf -m --preview="echo {} | awk '{print \$2}' | xargs git diff --color | tail -n +5" | awk '{print $2}' | perl -pe 's/\n/ /g' | sed 's/ $//')
  # git add $selected
  #
  local selected
  selected=$(git status -s | fzf -m --preview="echo {} | awk '{print \$2}' | xargs git diff --color | tail -n +5" | awk '{print $2}')
  if [ "$selected" ]; then
    mapfile -t FILES <<<"$selected"
    for FILE in "${FILES[@]}"; do
      git add "$FILE"
    done
  fi
}
