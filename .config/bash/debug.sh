#!/bin/bash

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
