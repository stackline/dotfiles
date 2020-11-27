# shellcheck shell=bash
# .bashrc

# User specific aliases and functions

# --------------------------------------
# Time measurement
# ref. https://www.golinuxcloud.com/get-script-execution-time-command-bash-script/
#
# Use my own tool because the BSD date command cannot display nanoseconds.
#
# ```sh
# $ go get github.com/stackline/mydate
# ```
# --------------------------------------
readonly script_start_time=$("$HOME"/go/bin/mydate)

# --------------------------------------
# XDG Base Directory
# ref. https://wiki.archlinux.org/index.php/XDG_Base_Directory
# --------------------------------------
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export BUNDLE_USER_HOME="${XDG_CONFIG_HOME}/bundle"
export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}"/npm/npmrc

# Load utilities first
source ~/.config/bash/debug.sh

for file in ~/.config/bash/*; do
  source "$file"
done

homebrew::initialize
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

# Prevent the display of multibyte characters from being garbled on neovim's terminal
export LANG=C
export PATH="$HOMEBREW_PREFIX/opt/mysql@5.7/bin:$PATH"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

if is_mac; then
  # coc.nvim + coc-clangd uses clangd as language server.
  export PATH="/usr/local/opt/llvm/bin:$PATH"
fi
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
  # sexport LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib64"
fi

# --------------------------------------
# alias
# --------------------------------------
alias ga='git add'
alias gb='git branch'
alias gbv='git branch -v'
alias gc='git checkout'
alias gcm='git commit -m'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log'
alias glp='git log -p'
alias gpp='git pull -p'
alias gs='git status'
alias grep='grep --color=auto' # colorize the output
alias less='less -R'
alias ll='ls -al'
alias rg='rg -i'
# INFO: Need to install libpq with Homebrew
alias psql12='$HOMEBREW_PREFIX/opt/libpq/bin/psql'
alias shfmt='shfmt -i 2 -ci' # Google Style Guides
if type 'nvim' > /dev/null; then
  alias vi='nvim'
  alias vim='nvim'
fi
### execute command interactively
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

if is_mac; then
  alias ls='ls -G'
fi
if is_linux; then
  alias ls='ls --color=auto'
fi

# function aliases
alias b='g++run'
alias c='cbcopy'
alias g='go_to_repository'
alias j='jump-to-directory'
alias dcl='docker-container-login'
alias drm='docker-container-remove'
alias dps='docker ps'
alias dpsa='docker ps -a'

# --------------------------------------
# Utilities
# --------------------------------------

# Remove all packages
alias pip2-uninstall-all-packages='pip2 freeze | xargs pip2 uninstall -y'
alias pip3-uninstall-all-packages='pip3 freeze | xargs pip3 uninstall -y'
# ref. https://darryldias.me/12/remove-all-installed-homebrew-packages/
alias brew-remove-all-installed-packages='brew list | xargs brew remove --force --ignore-dependencies'

function update-various-packages() {
  local readonly vim_plug_update_log='/tmp/vim-plug-update.log'
  if [ -f "$vim_plug_update_log" ]; then
    touch "$vim_plug_update_log"
  fi

  local readonly vim_coc_update_sync_log='/tmp/vim-coc-update-sync.log'
  if [ -f "$vim_coc_update_sync_log" ]; then
    touch "$vim_coc_update_sync_log"
  fi

  # --headless
  #   Do not switch screen from shell to vim.
  # set modifiable
  #   Enable to modify buffer.
  # %w
  #   % means all lines for range.
  #   %w means write all lines to a file.
  nvim --headless -c 'PlugUpdate' -c 'set modifiable' -c "%w $vim_plug_update_log" -c 'qa'
  echo ''
  # sleep
  #   Since the update is performed asynchronously, if we do not wait with sleep,
  #   the status during the update will be written to the log file.
  nvim --headless -c 'CocUpdateSync|sleep 3' -c 'set modifiable' -c "%w $vim_coc_update_sync_log" -c 'qa'
  echo ''

  echo -e '\n### update vim plugins\n'
  cat "$vim_plug_update_log"

  echo -e '\n### update coc.nvim extensions\n'
  cat "$vim_coc_update_sync_log"

  echo -e '\n### update homebrew formulas and casks\n'
  brew-maintenance
}

# Homebrew

# Avoid pyenv warnings when executing brew doctor
# ref. https://github.com/pyenv/pyenv/issues/106#issuecomment-190418988
function brew() {
  if command -v pyenv > /dev/null 2>&1; then
    PATH="${PATH//$(pyenv root)\/shims:/}" command brew "$@"
  else
    command brew "$@"
  fi
}

function brew-maintenance() {
  brew upgrade # includes formula updating and cache deletion
  is_mac && brew cu -a
  brew doctor
}

function git-show-pull-request() {
  if [ -z "$GIT_SHOW_PULL_REQUEST_URL" ]; then
    echo 'Set environment variable "GIT_SHOW_PULL_REQUEST_URL"'
    return 1
  fi

  declare -r URL_TEMPLATE=$GIT_SHOW_PULL_REQUEST_URL
  declare -r REGEXP="Merge pull request #([0-9]+)"
  local commit_hash
  local commit_message
  local repository_name
  local pull_request_number

  commit_hash=$1
  commit_message=$(git log --merges --oneline --ancestry-path "$commit_hash"...master | grep 'Merge pull request #' | tail -n 1)

  if [[ $commit_message =~ $REGEXP ]]; then
    repository_name=$(git rev-parse --show-toplevel | xargs basename)
    pull_request_number=${BASH_REMATCH[1]}
    echo "$commit_message"
    tmp="${URL_TEMPLATE/__REPOSITORY_NAME__/$repository_name}"
    echo "${tmp/__PULL_REQUEST_NUMBER__/$pull_request_number}"
  fi
}

# Show dependencies for installed formulaes
# ref. https://zanshin.net/2014/02/03/how-to-list-brew-dependencies/
function brew-dependencies() {
  local formula

  brew list | while read -r formula; do
    echo -en "\\e[1;34m$formula ->\\e[0m"
    brew deps "$formula" | awk '{printf(" %s ", $0)}'
    echo ''
  done
}

function jump-to-directory() {
  local selected_dir
  selected_dir=$(fd --no-ignore --type d | fzf --reverse)

  if [ "$selected_dir" ]; then
    cd "$selected_dir" || return
  fi
}

# Select a command from history interactively
# ref. https://qiita.com/comuttun/items/f54e755f22508a6c7d78
function select-command-from-history() {
  local selected_command
  selected_command=$(history | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | fzf --reverse --query "$READLINE_LINE")

  READLINE_LINE="$selected_command"
  READLINE_POINT=${#selected_command}
}
bind -x '"\C-r": select-command-from-history'

function docker-container-login() {
  local container_name
  container_name=$(docker ps --format "{{.Names}}" | fzf -1 -q "$1")

  if [ -n "$container_name" ]; then
    docker exec -it "$container_name" /bin/bash
  fi
}

function docker-container-remove() {
  local container_name
  container_name=$(docker ps -a --format "{{.Names}}" | fzf -q "$1")

  if [ -n "$container_name" ]; then
    docker rm "$container_name"
  fi
}

function check-trailing-character-hexdump() {
  tail -c 1 "$1" | xxd -p
}

# Colorize the output of man
# ref. https://wiki.archlinux.org/index.php/Color_output_in_console#man
function man() {
  LESS_TERMCAP_md=$'\e[01;31m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;44;33m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' \
  command man "$@"
}

alias check-path='echo $PATH | perl -pe "s/:/\n/g"'
# Optimize duplicate path entries.
#
# How to build
#
# ```sh
# $ go build -o /usr/local/bin/dietpath ./tools/dietpath/main.go
# ```
PATH=$(dietpath)
export PATH

readonly script_end_time=$("$HOME"/go/bin/mydate)
readonly bashrc_execution_msec=$(echo "($script_end_time - $script_start_time) * 1000" | bc | xargs printf "%.0f")
readonly bashrc_execution_sec=$(echo "($script_end_time - $script_start_time)" | bc | xargs printf "%.3f")
echo "Script execution Time: $bashrc_execution_msec msec ($bashrc_execution_sec sec)"
