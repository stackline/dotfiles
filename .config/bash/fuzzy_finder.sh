#!/bin/bash

function fzf_cd_directory() {
  local selected_dir
  selected_dir=$(fd --no-ignore --type d | fzf --reverse)

  if [ "$selected_dir" ]; then
    cd "$selected_dir" || return
  fi
}

function fzf_cd_repository() {
  local selected_dir
  selected_dir=$(ghq list --full-path | fzf --reverse)

  if [ -d "$selected_dir" ]; then
    cd "$selected_dir" || return 1
  fi
}

function fzf_docker_container_login() {
  local container_name
  container_name=$(docker ps --format "{{.Names}}" | fzf -1 -q "$1")

  if [ -n "$container_name" ]; then
    docker exec -it "$container_name" /bin/bash
  fi
}

function fzf_docker_container_remove() {
  local container_name
  container_name=$(docker ps -a --format "{{.Names}}" | fzf -q "$1")

  if [ -n "$container_name" ]; then
    docker rm "$container_name"
  fi
}

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

function fzf_history_search() {
  local selected_command
  selected_command=$(history | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | fzf --reverse --query "$READLINE_LINE")

  READLINE_LINE="$selected_command"
  READLINE_POINT=${#selected_command}
}
