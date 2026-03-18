#!/bin/bash
#
# Initialize shell prompt.

function prompt::check_dependencies() {
  local git_prompt_file="$1"
  local exit_status=0
  if [ -z "$HOMEBREW_PREFIX" ]; then
    echo 'warning: HOMEBREW_PREFIX variable is empty. Please check Homebrew config.'
    exit_status=1
  fi
  if [ ! -f "$git_prompt_file" ]; then
    echo 'warning: git-prompt.sh does not exist. Please install git with Homebrew.'
    exit_status=1
  fi
  return $exit_status
}

function prompt::initialize_git_prompt {
  local git_prompt_file="$1"
  source "$git_prompt_file"
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
  # Use ANSI escape codes directly instead of tput to avoid spawning external
  # processes on every shell startup, which reduces .bashrc execution time.
  # ref. Xterm Number https://jonasjacek.github.io/colors/
  local red=$'\[\e[91m\]'
  local lime=$'\[\e[92m\]'
  local blue=$'\[\e[94m\]'
  local reset=$'\[\e[0m\]'

  PS1="${lime}${USER_NAME}:${blue}${DIRECTORY}${red}\$(__git_ps1)\n${reset}\$ "
}

function prompt::initialize() {
  local git_prompt_file="${HOMEBREW_PREFIX}/etc/bash_completion.d/git-prompt.sh"
  if ! prompt::check_dependencies "$git_prompt_file"; then
    return 1
  fi
  prompt::initialize_git_prompt "$git_prompt_file"
  prompt::customize_bash_ps1
}
