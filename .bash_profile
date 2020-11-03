# shellcheck shell=bash
# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# User specific environment and startup programs

# --------------------------------------
# bash-completion
# --------------------------------------
readonly BASH_COMPLETION_SH_PATH="$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
[ -r "$BASH_COMPLETION_SH_PATH" ] && . "$BASH_COMPLETION_SH_PATH"
