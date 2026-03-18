#!/bin/bash

if command -v direnv >/dev/null 2>&1; then
  # Cache the hook output and regenerate only when the direnv binary is updated.
  # Clear manually with: rm "$XDG_CACHE_HOME/direnv/hook.sh"
  _direnv_cache="${XDG_CACHE_HOME}/direnv/hook.sh"
  if [[ ! -f "$_direnv_cache" || "${HOMEBREW_PREFIX}/bin/direnv" -nt "$_direnv_cache" ]]; then
    mkdir -p "${XDG_CACHE_HOME}/direnv"
    direnv hook bash > "$_direnv_cache"
  fi
  source "$_direnv_cache"
  unset _direnv_cache
fi
