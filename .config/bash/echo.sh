#!/bin/bash
#
# Example usage:
#
# $ echo::green "$(echo::bold 'set foreground color as green bold and execute echo.')"
#

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

function echo::green() {
  echo "$GREEN$*$RESET"
}

function echo::yellow() {
  echo "$YELLOW$*$RESET"
}

function echo::bold() {
  echo "$BOLD$*$RESET"
}
