#!/bin/bash

# The number of commands to remember in the command history.
HISTSIZE=1000 # default: 500

# The maximum number of lines contained in the history file.
HISTFILESIZE=$HISTSIZE # default: $HISTSIZE

# A colon-separated list of values controlling how commands are saved on
# the history list.
#
#   ignorespace ... Ignore an entry like " cd".
#   ignoredups  ... Ignore the same entry as the previous entry.
#   erasedups   ... Remove the same entry as the current entry from history list.
#
HISTCONTROL=ignorespace:ignoredups:erasedups

# Feature similar to Zsh's SHARE_HISTORY
# ref. https://unix.stackexchange.com/a/18443
function share_history {
  history -a # Append history list from this session to the history file.
  history -c # clear history list
  history -r # history file --> history list
}
PROMPT_COMMAND='share_history'

# -s
#
#   Set (enable) the option.
#
# histappend
#
#   Append history list to the history file when the shell exits,
#   rather than overwriting the file.
#
shopt -s histappend # default: off
