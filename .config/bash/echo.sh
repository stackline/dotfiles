#!/bin/bash
#
# Example usage:
#
# $ echo::green "$(echo::bold 'set foreground color as green bold and execute echo.')"
#

# Use ANSI escape codes directly instead of tput to avoid spawning external
# processes on every shell startup, which reduces .bashrc execution time.
RED=$'\e[31m'
GREEN=$'\e[32m'
YELLOW=$'\e[33m'
BOLD=$'\e[1m'
RESET=$'\e[0m'

function echo::green() {
  echo "$GREEN$*$RESET"
}

function echo::yellow() {
  echo "$YELLOW$*$RESET"
}

function echo::bold() {
  echo "$BOLD$*$RESET"
}
