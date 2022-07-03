#!/bin/bash

# Optimize duplicate path entries.
function dietpath_wrapper() {
  if command -v dietpath >/dev/null 2>&1; then
    dietpath
  else
    cat <<EOS >&2
[warning] Compile dietpath package in dotfiles repository.
=> go build -o "${HOMEBREW_PREFIX}"/bin/dietpath ./tools/dietpath/main.go
EOS
    echo "$PATH"
  fi
}
