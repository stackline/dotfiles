#!/bin/bash

function homebrew::initialize() {
  eval "$(/opt/homebrew/bin/brew shellenv)"

  export HOMEBREW_NO_ANALYTICS=1
  # Do not install dependent build tools
  export HOMEBREW_NO_BOTTLE_SOURCE_FALLBACK=1
  # Do not generate Brewfile.lock.json
  export HOMEBREW_BUNDLE_NO_LOCK=1
}
