#!/bin/bash

export HOMEBREW_NO_ANALYTICS=1
# Do not install dependent build tools
export HOMEBREW_NO_BOTTLE_SOURCE_FALLBACK=1
# Do not generate Brewfile.lock.json
export HOMEBREW_BUNDLE_NO_LOCK=1
# Do not print any hints.
export HOMEBREW_NO_ENV_HINTS=1

# Avoid pyenv warnings when executing brew doctor
# ref. https://github.com/pyenv/pyenv/issues/106#issuecomment-190418988
function brew() {
  if command -v pyenv >/dev/null 2>&1; then
    PATH="${PATH//$(pyenv root)\/shims:/}" command brew "$@"
  else
    command brew "$@"
  fi
}
