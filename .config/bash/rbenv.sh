#!/bin/bash

export RBENV_ROOT="${XDG_DATA_HOME}/rbenv"

if command -v rbenv > /dev/null 2>&1; then
  export PATH="${RBENV_ROOT}/shims:${PATH}"

  function rbenv() {
    unset rbenv # remove function itself
    eval "$(rbenv init -)"
    PATH=$(dietpath)
    export PATH
    rbenv "$@"
  }
fi
