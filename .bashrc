# shellcheck shell=bash
# .bashrc

# User specific aliases and functions

# --------------------------------------
# Time measurement
# ref. https://www.golinuxcloud.com/get-script-execution-time-command-bash-script/
#
# Use my own tool because the BSD date command cannot display nanoseconds.
# --------------------------------------
script_start_time=$("$HOME"/go/bin/mydate)

# --------------------------------------
# XDG Base Directory
# ref. https://wiki.archlinux.org/index.php/XDG_Base_Directory
# --------------------------------------
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export BUNDLE_USER_HOME="${XDG_CONFIG_HOME}/bundle"

# Initialize Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load utilities first
source ~/.config/bash/debug.sh

for file in ~/.config/bash/*; do
  source "$file"
done

prompt::initialize

# --------------------------------------
# Add environment variables by using allexport
# --------------------------------------
if [ -f ~/.env ]; then
  set -a
  eval "$(cat ~/.env)"
  set +a
fi

# --------------------------------------
# export
# --------------------------------------
if is_linux; then
  # Correspondence of garbled characters when displaying Japanese with less
  export LESSCHARSET=utf-8
  # Avoid error when starting tmux
  # ref. https://astropengu.in/blog/12/
  #      https://github.com/Linuxbrew/legacy-linuxbrew/issues/46#issuecomment-120759893
  export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/share/pkgconfig
  # Node pngquant package references libpng12.so.0.
  #
  # - Install yum libpng package
  # - Add "/usr/lib64" to LD_LIBRARY_PATH
  #
  # Without LD_LIBRARY_PATH environment variable below, the following error occurs at execution.
  #
  # - Error: node_modules/pngquant-bin/vendor/pngquant: error while loading shared libraries: libpng12.so.0: cannot open shared object file: No such file or directory
  #
  # Also, homebrew's libpng package is version 1.6.
  #
  # The following error occurs in CentOS7.
  #
  # - tput: relocation error: /usr/lib64/libc.so.6: symbol _dl_starting_up, version GLIBC_PRIVATE not defined in file ld-linux-x86-64.so.2 with link time reference
  #
  # export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib64"
fi

# --------------------------------------
# alias
# --------------------------------------
# General command aliases
alias cp='cp -i'               # Interactively
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

if command -v "$HOME/go/bin/mydate" 1>/dev/null 2>/dev/null; then
  script_end_time=$("$HOME"/go/bin/mydate)
  bashrc_execution_msec=$(echo "($script_end_time - $script_start_time) * 1000" | bc | xargs printf "%.0f")
  bashrc_execution_sec=$(echo "($script_end_time - $script_start_time)" | bc | xargs printf "%.3f")
  echo "Script execution Time: $bashrc_execution_msec msec ($bashrc_execution_sec sec)"
else
  echo::yellow 'hint: Install mydate command to measure .bashrc execution time.'
  echo::yellow 'hint:'
  echo::yellow 'hint:   $ go install github.com/stackline/mydate@latest'
  echo::yellow 'hint:'
fi
