#!/bin/bash

export PYENV_ROOT="${XDG_DATA_HOME}/pyenv"

if command -v pyenv > /dev/null 2>&1; then
  eval "$(pyenv init -)"

  # When the following situation is, it errors installing python with pyenv.
  #
  #   ### situation
  #   * OS is macOS.
  #   * LLVM of Homebrew is installed.
  #
  #   ### error message
  #   configure: error: cannot run C compiled programs.
  #
  #   ### reference
  #   https://github.com/pyenv/pyenv/issues/1348
  #
  # The following alias should use macOS standard clang instead of Homebrew clang.
  if is_mac; then
    alias pyenv="CC=/usr/bin/cc pyenv"
  fi
fi
