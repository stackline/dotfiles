# shellcheck shell=bash
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

if [ -f ~/.bashrc_local ]; then
  . ~/.bashrc_local
fi

# User specific environment and startup programs
