#!/bin/bash

export GOENV_ROOT="${XDG_DATA_HOME}/goenv"

if command -v goenv >/dev/null 2>&1; then
  export PATH="${GOENV_ROOT}/shims:${PATH}"

  function goenv() {
    unset goenv # remove function itself
    eval "$(goenv init -)"
    PATH=$(dietpath_wrapper)
    export PATH

    # goenv manages GOPATH and GOROOT (recommended)
    # ref: https://github.com/go-nv/goenv/blob/master/INSTALL.md
    export PATH="$GOROOT/bin:$PATH"
    export PATH="$PATH:$GOPATH/bin"

    goenv "$@"
  }
fi
