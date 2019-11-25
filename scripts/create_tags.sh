#!/bin/bash

function log() {
  local current_time
  local file_name
  local line_number

  current_time=$(date '+%Y-%m-%dT%H:%M:%S')
  file_name=$(basename "${BASH_SOURCE[0]}")
  line_number=${BASH_LINENO[0]}

  echo "$current_time $file_name:$line_number $1"
}

log 'start'

readonly PHP_TAGS="$HOME/.cache/ctags/php.tags"
readonly TEMPORARY_PHP_TAGS="$HOME/.cache/ctags/_php.tags"

ctags -R --languages=PHP -f "$TEMPORARY_PHP_TAGS" "$1" "$2" "$3"

[ -e "$PHP_TAGS" ] && rm "$PHP_TAGS"
mv "$TEMPORARY_PHP_TAGS" "$PHP_TAGS"

log 'finish'
