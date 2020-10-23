#!/bin/bash

export GOENV_ROOT="${XDG_DATA_HOME}/goenv"

if command -v goenv > /dev/null 2>&1; then
  eval "$(goenv init -)"
fi
