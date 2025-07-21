#!/bin/bash

if [[ -z "${HOMEBREW_CELLAR}" || ! -d "${HOMEBREW_CELLAR}/goenv" ]]; then
  return
fi

export GOENV_ROOT="${XDG_DATA_HOME}/goenv"

if command -v goenv >/dev/null 2>&1; then
  export PATH="${GOENV_ROOT}/shims:${PATH}"

  function goenv() {
    unset goenv # remove function itself
    eval "$(goenv init -)"
    PATH=$(dietpath_wrapper)
    export PATH
    goenv "$@"
  }
fi
