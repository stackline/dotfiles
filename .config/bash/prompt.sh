#!/bin/bash
#
# Initialize shell prompt.

function prompt::build_git_prompt_file_path() {
  echo "$HOMEBREW_PREFIX/etc/bash_completion.d/git-prompt.sh"
}

function prompt::check_dependencies() {
  local exit_status=0
  if [ -z "$HOMEBREW_PREFIX" ]; then
    echo 'warning: HOMEBREW_PREFIX variable is empty. Please check Homebrew config.'
    exit_status=1
  fi
  if [ ! -f "$(prompt::build_git_prompt_file_path)" ]; then
    echo 'warning: git-prompt.sh does not exist. Please install git with Homebrew.'
    exit_status=1
  fi
  return $exit_status
}

function prompt::initialize_git_prompt {
  source "$(prompt::build_git_prompt_file_path)"
  # NOTE: If I enable GIT_PS1_SHOWDIRTYSTATE and GIT_PS1_SHOWUNTRACKEDFILES,
  # __git_ps1 command is sometimes slow, so disable them.
  # Since it doesn't refer to GIT_PS1_SHOWSTASHSTATE very much, it is also disabled.
  #
  # export GIT_PS1_SHOWDIRTYSTATE=1
  # export GIT_PS1_SHOWUNTRACKEDFILES=1
  # export GIT_PS1_SHOWSTASHSTATE=1
  export GIT_PS1_SHOWUPSTREAM=1
}

function prompt::customize_bash_ps1() {
  local -r USER_NAME='\u'
  local -r HOST_NAME='\h'
  local -r DIRECTORY='\w'
  local red
  local lime
  local blue
  local reset

  # ref. Xterm Number https://jonasjacek.github.io/colors/
  red="\[$(tput setaf 9)\]"
  lime="\[$(tput setaf 10)\]"
  blue="\[$(tput setaf 12)\]"
  reset="\[$(tput sgr0)\]"

  PS1="${lime}${USER_NAME}@${HOST_NAME}${blue}:${DIRECTORY}${red}\$(__git_ps1)\n${reset}\$ "
}

function prompt::initialize() {
  if ! prompt::check_dependencies; then
    return 1
  fi
  prompt::initialize_git_prompt
  prompt::customize_bash_ps1
}
