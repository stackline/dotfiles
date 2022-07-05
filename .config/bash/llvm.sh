#!/bin/bash

# If LLVM is installed, add the path to use clangd.
if [ -d "$HOMEBREW_CELLAR/llvm" ];
then
  export PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
fi
