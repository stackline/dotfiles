#!/bin/bash

function help::manpage_format() {
  ### Build header
  # Left and right part
  name=$(echo -n "$@" | tr '[:lower:]' '[:upper:]')
  section='(1)'
  manual_page="${name}${section}"

  # Center part
  manual_type='Builtin Commands Manual'

  # Space part
  current_terminal_width=$(tput cols)
  # TODO: 25 is an appropriately determined number.
  # To flexibly decide the layout, change the calculation method.
  half_width=$((current_terminal_width / 2 - 25))
  spaces=$(printf "%${half_width}s")

  header="${manual_page}${spaces}${manual_type}${spaces}${manual_page}"

  ### Build manual
  manual="${header}\n\n$(help -m "$@")"

  echo -e "${manual}" | bat -l man -p
}

# Display the manual of Bash built-in command with "help" command.
function man() {
  manual_file_name=$(command man -w "$@" 2>/dev/null | xargs basename)

  if [ "$manual_file_name" == 'builtin.1' ]; then
    help::manpage_format "$@"
  else
    # ref. https://github.com/sharkdp/bat#man
    MANPAGER="sh -c 'col -bx | bat -l man -p'" \
      command man "$@"
  fi
}
