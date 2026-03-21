# shellcheck shell=bash
# .bashrc

# User specific aliases and functions

# --------------------------------------
# Time measurement (bash 5.0+ only)
# $EPOCHREALTIME is a bash 5.0+ builtin variable, no external process needed.
# --------------------------------------
if (( ${BASH_VERSINFO[0]} >= 5 )); then
  _bashrc_start=$EPOCHREALTIME
fi

# --------------------------------------
# XDG Base Directory
# ref. https://wiki.archlinux.org/index.php/XDG_Base_Directory
# --------------------------------------
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export BUNDLE_USER_HOME="${XDG_CONFIG_HOME}/bundle"

# Initialize Homebrew (cached; clear with: rm "$XDG_CACHE_HOME/homebrew/shellenv.sh")
_brew_cache="${XDG_CACHE_HOME}/homebrew/shellenv.sh"
if [[ ! -f "$_brew_cache" ]]; then
  mkdir -p "${XDG_CACHE_HOME}/homebrew"
  /opt/homebrew/bin/brew shellenv > "$_brew_cache"
fi
source "$_brew_cache"
unset _brew_cache

# Load utilities first
for file in ~/.config/bash/*.sh; do
  source "$file"
done

prompt::initialize

# --------------------------------------
# Add environment variables by using allexport
# --------------------------------------
if [ -f ~/.env ]; then
  set -a
  source ~/.env
  set +a
fi

# --------------------------------------
# alias
# --------------------------------------
# General command aliases
alias cp='cp -i'               # Interactively
alias difff='git diff --no-index' # Show colored diff of two files.
alias grep='grep --color=auto' # Colorize output
alias less='less -R'
alias ll='ls -al'
alias ls='ls --color=auto'     # NOTE: GNU coreutils ls "-G" option is not Colorized.
alias mv='mv -i'               # Interactively
alias rg='rg -i'
alias rm='rm -i'               # Interactively

# Git (prefix: g)
alias ga='fzf_git_add'
alias gb='git branch -v'
alias gc='git commit'
alias gcdf='git clean -df'
alias gd='git diff'
alias gdc='git diff --cached'
alias gg='cd `git rev-parse --show-toplevel`' # move to top-level directory
alias gl='git log'
alias glp='git log -p'
alias gp='git pull -p'
alias gr='git restore'
alias grs='git restore --staged'
alias gs='git status'
alias gss='git branch | fzf | xargs git switch'

if type 'nvim' >/dev/null; then
  alias vi='nvim'
  alias vim='nvim'
fi

# function aliases
alias b='g++run'
alias d='docker'
alias dc='docker compose'
alias g='fzf_cd_repository'
alias j='fzf_cd_directory'
alias k='kubectl'
alias dcl='fzf_docker_container_login'
alias drm='fzf_docker_container_remove'
alias check-path='echo $PATH | perl -pe "s/:/\n/g"'
alias gem-uninstall-all-gems-except-default='gem uninstall -a -x --user-install --force'
alias ssh-add-apple-use-keychanin='ssh-add --apple-use-keychain'

# --------------------------------------
# Helper functions
# --------------------------------------
function clip() { pbcopy < "$1"; }

function is_interactive() {
  local shell_option_flags="$-"
  [[ "${shell_option_flags}" == *i* ]]
}

# --------------------------------------
# Key bindings
# --------------------------------------
# Set key bindings only for interactive shells. The `bind` command will issue a
# warning if the shell is not interactive.
if is_interactive; then
  bind -x '"\C-r": fzf_history_search'
fi

# --------------------------------------
# Utilities
# --------------------------------------
function update-various-packages() {
  echo::bold '[neovim: lazy check]'
  nvim --headless "+Lazy! check" +qa

  echo '' # spacer

  echo::bold '[neovim: lazy sync]'
  nvim --headless "+Lazy! sync" +qa

  echo '' # spacer

  echo::bold '[neovim: mason update]'
  nvim --headless -c "luafile $HOME/.config/nvim/headless/mason_update.lua"

  echo '' # spacer

  echo::bold '[homebrew: brew update]'
  brew update

  echo '' # spacer

  echo::bold '[homebrew: brew upgrade --greedy-auto-updates]'
  brew upgrade --greedy-auto-updates

  echo '' # spacer

  echo::bold '[homebrew: brew autoremove]'
  brew autoremove # Uninstall formulae that are no longer needed.

  echo '' # spacer

  echo::bold '[homebrew: brew doctor]'
  brew doctor

  echo '' # spacer

  if command -v npm 1>/dev/null 2>/dev/null; then
    echo::bold '[npm: npm outdated -g]'
    npm outdated -g

    # TODO: Update only if outdated packages exist.
    # npm update -g
  fi
}

function check-trailing-character-hexdump() {
  tail -c 1 "$1" | xxd -p
}

PATH=$(dietpath_wrapper)
export PATH

if (( ${BASH_VERSINFO[0]} >= 5 )); then
  _bashrc_end=$EPOCHREALTIME
  awk "BEGIN { d = $_bashrc_end - $_bashrc_start; printf \"Script execution Time: %.0f msec (%.3f sec)\n\", d*1000, d }"
fi
