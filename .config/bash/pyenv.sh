#!/bin/bash

export PYENV_ROOT="${XDG_DATA_HOME}/pyenv"

if command -v pyenv >/dev/null 2>&1; then
  export PATH="${PYENV_ROOT}/shims:${PATH}"

  function pyenv() {
    unset pyenv # remove function itself
    eval "$(pyenv init -)"
    PATH=$(dietpath_wrapper)
    export PATH

    pyenv "$@"
  }
fi
