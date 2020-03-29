# .bashrc

# User specific environment and startup programs

CURRENT_SHELL=$0
for file in ~/.config/bash/*; do
  source "$file"
done

# --------------------------------------
# Export
# --------------------------------------
function export_mac_environments() {
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
  export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
  export PATH="/usr/local/opt/postgresql@9.5/bin:$PATH" # Need pg_config to install pg gem
}

function export_linux_environments() {
  export LESSCHARSET=utf-8
  export PATH="/home/linuxbrew/.linuxbrew/opt/postgresql@9.5/bin:$PATH" # Need pg_config to install pg gem
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
}

is_mac && export_mac_environments
is_linux && export_linux_environments
homebrew::initialize
prompt::initialize

# --------------------------------------
# Time measurement
# ref. https://www.golinuxcloud.com/get-script-execution-time-command-bash-script/
# --------------------------------------
function get_current_time_with_nanosec() {
  date +%s.%N
}

function calc_script_execution_time() {
  local start_time=$1
  local end_time=$2
  local duration
  local formatted_duration

  duration=$(echo "$end_time - $start_time" | bc)
  formatted_duration=$(printf "%.2f" "$duration")
  echo "$formatted_duration"
}

readonly script_start_time=$(get_current_time_with_nanosec)

# --------------------------------------
# Add environment variables by using allexport
# --------------------------------------
if [ -f ~/.env ]; then
  set -a
  eval "$(cat ~/.env)"
  set +a
fi


# --------------------------------------
# Node
# --------------------------------------
if command -v nodenv > /dev/null 2>&1; then
  eval "$(nodenv init -)"

  # use lint tools globally
  export PATH="$HOME/dev/src/github.com/stackline/dotfiles/node_modules/.bin:$PATH"
  # Use yarn with coc.nvim
  export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
fi


# --------------------------------------
# Ruby
# --------------------------------------
if command -v rbenv > /dev/null 2>&1; then
  export RBENV_ROOT="$HOME/.rbenv"
  eval "$(rbenv init -)"
fi


# --------------------------------------
# Python
# --------------------------------------
if command -v pyenv > /dev/null 2>&1; then
  export PYENV_ROOT="$HOME/.pyenv"
  eval "$(pyenv init -)"
fi


# --------------------------------------
# Bash completion
# MEMO: Homebrew git formula install to bash_completion.d
# --------------------------------------
### Homebrew
# shellcheck disable=SC1091
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

### Linuxbrew
[ -f /home/linuxbrew/.linuxbrew/etc/bash_completion ] && . /home/linuxbrew/.linuxbrew/etc/bash_completion
# Git's completion does not work so apply the following patch.
[ -f /home/linuxbrew/.linuxbrew/etc/bash_completion.d/git-completion.bash ] && source /home/linuxbrew/.linuxbrew/etc/bash_completion.d/git-completion.bash


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
alias g='go_to_repository'

# --------------------------------------
# Utilities
# --------------------------------------

# Remove all packages
alias pip2-uninstall-all-packages='pip2 freeze | xargs pip2 uninstall -y'
alias pip3-uninstall-all-packages='pip3 freeze | xargs pip3 uninstall -y'
# ref. https://darryldias.me/12/remove-all-installed-homebrew-packages/
alias brew-remove-all-installed-packages='brew list | xargs brew remove --force --ignore-dependencies'

# Update packages
# Visual Studio Code
function update-vscode-extensions() {
  local installed_extensions
  # @see https://github.com/koalaman/shellcheck/wiki/SC2207
  mapfile -t installed_extensions < <(code --list-extensions)

  for e in "${installed_extensions[@]}"; do
    code --install-extension "${e}" --force
  done
}

# Vim
# modifiable config are required when writing file.
function update-vim-plugins() {
  nvim -c 'PlugUpdate' -c 'set modifiable' -c '%w /tmp/vim-plug.log' -c 'qa'
  cat /tmp/vim-plug.log
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
  brew update
  brew upgrade
  is_mac && brew cu -a
  # Delete the cache of uninstalled formulas with the "-s" option
  brew cleanup -s
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
alias j='jump-to-directory'

# Select a command from history interactively
# ref. https://qiita.com/comuttun/items/f54e755f22508a6c7d78
function select-command-from-history() {
  local selected_command
  selected_command=$(history | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | fzf --reverse --query "$READLINE_LINE")

  READLINE_LINE="$selected_command"
  READLINE_POINT=${#selected_command}
}
if [ "$CURRENT_SHELL" = 'bash' ]; then
  bind -x '"\C-r": select-command-from-history'
fi

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

# Delete PATH dupulication
# ref. https://qiita.com/b4b4r07/items/45d34a434f05aa896d69
alias check-path='echo $PATH | perl -pe "s/:/\n/g"'

_p=$(echo "$PATH" | tr ':' '\n' | awk '!a[$0]++' | awk 'NF' | tr '\n' ':' | sed -e s/:$//)
PATH=$_p
unset _p

readonly script_end_time=$(get_current_time_with_nanosec)
readonly execution_time=$(calc_script_execution_time "$script_start_time" "$script_end_time")
echo "Script execution Time: $execution_time"
