# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  # shellcheck source=/dev/null
  . ~/.bashrc
fi

# User specific environment and startup programs

# --------------------------------------
# Check OS
# --------------------------------------
is_mac() {
  [ "$(uname)" == "Darwin" ] && return 0
  return 1
}

is_linux() {
  [ "$(uname)" == "Linux" ] && return 0
  return 1
}


# --------------------------------------
# Add environment variables by using allexport
# --------------------------------------
set -a
eval "$(cat ~/.env)"
set +a


# --------------------------------------
# Linuxbrew
# --------------------------------------
export_linuxbrew_path() {
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
  # Warning: Homebrew's sbin was not found in your PATH but you have installed formulae that put executables in /home/linuxbrew/.linuxbrew/sbin.
  export PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"
  # PostgreSQL (psql command)
  export PATH="/home/linuxbrew/.linuxbrew/opt/postgresql@9.5/bin:$PATH"

  export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
}
if is_linux; then
  export_linuxbrew_path
fi


# --------------------------------------
# Homebrew
# --------------------------------------
export HOMEBREW_NO_ANALYTICS=1
# Increase access limit to Github by using the API key
# ref. https://rcmdnk.com/blog/2013/12/05/mac-homebrew/
# shellcheck source=/dev/null
[ -f ~/.homebrew_github_api_token ] && source ~/.homebrew_github_api_token


# --------------------------------------
# Version manager
# --------------------------------------
### rbenv
export RBENV_ROOT="$HOME/.rbenv"
eval "$(rbenv init -)"

### nodenv
eval "$(nodenv init -)"


# --------------------------------------
# Git
# --------------------------------------
# GIT_PS1_SHOWDIRTYSTATE=1
# GIT_PS1_SHOWSTASHSTATE=1
# GIT_PS1_SHOWUPSTREAM=1
# GIT_PS1_SHOWUNTRACKEDFILES=1


# --------------------------------------
# Bash completion
# MEMO: Homebrew git formula install to bash_completion.d
# --------------------------------------
### Homebrew
# shellcheck disable=SC1091
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

### Linuxbrew
[ -f /home/linuxbrew/.linuxbrew/etc/bash_completion ] && . /home/linuxbrew/.linuxbrew/etc/bash_completion
[ -f /home/linuxbrew/.linuxbrew/etc/bash_completion.d/git-prompt.sh ] && source /home/linuxbrew/.linuxbrew/etc/bash_completion.d/git-prompt.sh


# --------------------------------------
# Bash prompt
# ref. XTerm Number https://jonasjacek.github.io/colors/
# --------------------------------------
RED="\\[$(tput setaf 9)\\]"
GREEN="\\[$(tput setaf 10)\\]"
# YELLOW="\\[$(tput setaf 11)\\]"
BLUE="\\[$(tput setaf 12)\\]"
RESET="\\[$(tput sgr0)\\]"
PROMPT_COMMAND='__git_ps1 "${GREEN}\u@\h${BLUE}:\w${RED}" "${RESET}\n\\\$ "'


# --------------------------------------
# alias
# --------------------------------------
alias ga='git add'
alias gb='git branch -v'
alias gcm='git commit -m'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log'
alias glp='git log -p'
alias gpp='git pull -p'
alias gs='git status'
alias less='less -R'
alias ll='ls -al'
alias rg='rg -i'
alias vi='nvim'
alias vim='nvim'
### execute command interactively
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

if is_mac; then
  alias ls='ls -G'
fi
if is_linux; then
  alias ls='ls -G --color=auto'
fi


# --------------------------------------
# Utilities
# --------------------------------------
# Remove all installed Homebrew packages
# ref. https://darryldias.me/12/remove-all-installed-homebrew-packages/
alias brew-remove-all-installed-packages='brew list | xargs brew remove --force --ignore-dependencies'

# Maintain Homebrew packages
alias brew-maintenance='brew update && brew upgrade && brew prune && brew cleanup && brew doctor'

git-show-pull-request() {
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
    tmp="${URL_TEMPLATE/REPOSITORY_NAME/$repository_name}"
    echo "${tmp/PULL_REQUEST_NUMBER/$pull_request_number}"
  fi
}

# Show dependencies for installed formulaes
# ref. https://zanshin.net/2014/02/03/how-to-list-brew-dependencies/
brew-dependencies() {
  local formula

  brew list | while read -r formula; do
    echo -en "\\e[1;34m$formula ->\\e[0m"
    brew deps "$formula" | awk '{printf(" %s ", $0)}'
    echo ''
  done
}

# Change directory to specific repository
# ref. https://weblog.bulknews.net/ghq-peco-percol-b6be7828dc1b
peco-src() {
  local selected_dir
  selected_dir=$(ghq list --full-path | peco)

  if [ "$selected_dir" ]; then
    cd "$selected_dir" || return
  fi
}
alias g='peco-src'

# Select a command from history interactively
# ref. https://qiita.com/comuttun/items/f54e755f22508a6c7d78
peco-select-history() {
  local selected_command
  selected_command=$(history | sort -k1,1nr | perl -ne 'BEGIN { my @lines = (); } s/^\s*\d+\s*//; $in=$_; if (!(grep {$in eq $_} @lines)) { push(@lines, $in); print $in; }' | peco --query "$READLINE_LINE")

  READLINE_LINE="$selected_command"
  READLINE_POINT=${#selected_command}
}
bind -x '"\C-r": peco-select-history'

# Delete PATH dupulication
# ref. https://qiita.com/b4b4r07/items/45d34a434f05aa896d69
alias check-path='echo $PATH | perl -pe "s/:/\n/g"'

_p=$(echo "$PATH" | tr ':' '\n' | awk '!a[$0]++' | awk 'NF' | tr '\n' ':' | sed -e s/:$//)
PATH=$_p
unset _p

