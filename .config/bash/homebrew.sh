#!/bin/bash
#
# Initialize Homebrew.

function homebrew::initialize() {
  # NOTE: Same as `eval "$(brew shellenv)"`
  #       Execution time of `brew shellenv` takes about 0.1 to 0.2 seconds.
  case $(uname) in
    'Darwin' )
      export HOMEBREW_PREFIX="/usr/local";
      export HOMEBREW_CELLAR="/usr/local/Cellar";
      export HOMEBREW_REPOSITORY="/usr/local/Homebrew";
      export PATH="/usr/local/bin:/usr/local/sbin${PATH+:$PATH}";
      export MANPATH="/usr/local/share/man${MANPATH+:$MANPATH}:";
      export INFOPATH="/usr/local/share/info${INFOPATH+:$INFOPATH}";
      ;;
    'Linux' )
      export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
      export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";
      export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";
      export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin${PATH+:$PATH}";
      export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:";
      export INFOPATH="/home/linuxbrew/.linuxbrew/share/info${INFOPATH+:$INFOPATH}";
      ;;
    * )
      echo 'warning: OS name is neither Mac nor Linux.'
      exit 1
      ;;
  esac
  export HOMEBREW_NO_ANALYTICS=1
  # Do not install dependent build tools
  export HOMEBREW_NO_BOTTLE_SOURCE_FALLBACK=1
  # Do not generate Brewfile.lock.json
  export HOMEBREW_BUNDLE_NO_LOCK=1
}
