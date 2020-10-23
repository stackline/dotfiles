#!/bin/bash

export NODENV_ROOT="${XDG_DATA_HOME}/nodenv"

if command -v nodenv > /dev/null 2>&1; then
  eval "$(nodenv init -)"
fi
