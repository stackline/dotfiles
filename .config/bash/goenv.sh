#!/bin/bash

export GOENV_ROOT="${XDG_DATA_HOME}/goenv"

if command -v goenv > /dev/null 2>&1; then
  export PATH="${GOENV_ROOT}/shims:${PATH}"

  function goenv() {
    unset goenv # remove function itself
    eval "$(goenv init -)"
    remove_duplicate_path_entries
    goenv "$@"
  }
fi
