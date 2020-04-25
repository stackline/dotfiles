#!/bin/bash

if [ "$CURRENT_SHELL" = 'bash' ]; then
  #######################################
  # Arguments:
  #   Warning message
  # Outputs:
  #   Write warning message to stdout
  #######################################
  function debug::warn() {
    local -r caller_file_name=$(basename "${BASH_SOURCE[1]}")
    local -r caller_line_number=${BASH_LINENO[0]}
    printf "\e[33;1m(%s:%s) warning: %s\e[0m\n" "${caller_file_name}" "${caller_line_number}" "${1}"
  }
elif [ "$CURRENT_SHELL" = 'zsh' ]; then
  #######################################
  # Arguments:
  #   Warning message
  # Outputs:
  #   Write warning message to stdout
  #######################################
  function debug::warn() {
    # funcfiletrace
    # ref. http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#The-zsh_002fparameter-Module
    #
    # SC2154: funcfiletrace is referenced but not assigned.
    # shellcheck disable=SC2154
    local -r caller_file_name=$(echo "${funcfiletrace[1]}" | cut -d : -f 1 | xargs basename)
    local -r caller_line_number=$(echo "${funcfiletrace[1]}" | cut -d : -f 2)

    # \e[  = Control Sequence Introducer
    # 33;1 = Color codes (COLOR;TEXT DECORATION)
    # m    = Finishing symbol
    printf "\e[33;1m(%s:%s) warning: %s\e[0m\n" "${caller_file_name}" "${caller_line_number}" "${1}"
  }
else
  printf "\e[33;1m(debug.sh) warning: CURRENT_SHELL is '%s'. debug.sh only supports Bash and Zsh.\e[0m\n" "${CURRENT_SHELL}"
fi
