#!/bin/bash

export NODENV_ROOT="${XDG_DATA_HOME}/nodenv"

if command -v nodenv > /dev/null 2>&1; then
  export PATH="${NODENV_ROOT}/shims:${PATH}"

  function nodenv() {
    unset nodenv # remove function itself
    eval "$(nodenv init -)"
    remove_duplicate_path_entries
    nodenv "$@"
  }
fi
