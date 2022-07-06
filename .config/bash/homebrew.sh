#!/bin/bash

export HOMEBREW_NO_ANALYTICS=1
# Do not install dependent build tools
export HOMEBREW_NO_BOTTLE_SOURCE_FALLBACK=1
# Do not generate Brewfile.lock.json
export HOMEBREW_BUNDLE_NO_LOCK=1
# Do not print any hints.
export HOMEBREW_NO_ENV_HINTS=1
