#!/bin/bash

export RBENV_ROOT="${XDG_DATA_HOME}/rbenv"

if command -v rbenv > /dev/null 2>&1; then
  eval "$(rbenv init -)"
fi
