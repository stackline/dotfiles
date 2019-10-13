#!/bin/bash

# Use diff-highlight only when enable to use it
if command -v diff-highlight > /dev/null 2>&1; then
  cat - | diff-highlight | less
else
  cat - | less
fi
