#!/bin/bash

# --------------------------------------
# constant
# --------------------------------------
readonly RUBY_PACKAGES=(
  mailcatcher
  neovim # required for deoplete-ruby
  rubocop
  rubocop-rspec
  slim_lint
  solargraph
)

# --------------------------------------
# Utilities
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
# Create global .gitconfig file
# --------------------------------------
create_git_config_file() {
  ### user
  [ "$GIT_GLOBAL_USER_NAME" ] && git config --global user.name "$GIT_GLOBAL_USER_NAME"
  [ "$GIT_GLOBAL_USER_EMAIL" ] && git config --global user.email "$GIT_GLOBAL_USER_EMAIL"

  ### core
  # shellcheck disable=SC2088
  git config --global core.excludesfile "~/.gitignore_global"

  ### diff
  # Highlight diff
  # ref. https://github.com/git/git/tree/master/contrib/diff-highlight
  git config --global pager.log "diff-highlight | less"
  git config --global pager.show "diff-highlight | less"
  git config --global pager.diff "diff-highlight | less"

  # Customized color for diff
  # ref. https://git-scm.com/docs/git-config#git-config-colordiffltslotgt
  git config --global color.diff.meta "magenta normal"

  # Highlight whitespace
  git config --global diff.wsErrorHighlight "all"

  ### ghq
  # shellcheck disable=SC2088
  git config --global ghq.root "~/dev/src"
}

# --------------------------------------
# Create symbolic links to files and directories
# --------------------------------------
create_symbolic_links() {
  local relative_file_name
  local relative_file_path
  local dotfiles_root_dir

  relative_file_name=$0
  relative_file_path=$(dirname "${relative_file_name}")
  dotfiles_root_dir=$(cd "${relative_file_path}" && pwd)
  echo current directory is "${dotfiles_root_dir}"

  ### make directories
  mkdir ~/dev/src # use git repositories
  mkdir ~/.bundle
  mkdir ~/.ctags.d
  mkdir ~/.composer
  mkdir ~/.config
  mkdir ~/.config/nvim
  mkdir ~/.config/peco
  mkdir ~/.config/pip

  # TODO: Delete a config file that exists on default
  ### root directory
  ln -s -v "${dotfiles_root_dir}"/.ansible-lint ~/.ansible-lint
  ln -s -v "${dotfiles_root_dir}"/.bash_profile ~/.bash_profile
  ln -s -v "${dotfiles_root_dir}"/.Brewfile ~/.Brewfile
  ln -s -v "${dotfiles_root_dir}"/.eslintrc.js ~/.eslintrc.js
  ln -s -v "${dotfiles_root_dir}"/.gemrc ~/.gemrc
  ln -s -v "${dotfiles_root_dir}"/.gitignore_global ~/.gitignore_global
  ln -s -v "${dotfiles_root_dir}"/.htmllintrc ~/.htmllintrc
  ln -s -v "${dotfiles_root_dir}"/.pryrc ~/.pryrc
  ln -s -v "${dotfiles_root_dir}"/.tmux.conf ~/.tmux.conf

  ### sub directory
  ln -s -v "${dotfiles_root_dir}"/.bundle/config ~/.bundle/config
  ln -s -v "${dotfiles_root_dir}"/.ctags.d/config.ctags ~/.ctags.d/config.ctags
  ln -s -v "${dotfiles_root_dir}"/.composer/composer.json ~/.composer/composer.json

  ### .config directory
  ln -s -v "${dotfiles_root_dir}"/.config/nvim/init.vim ~/.config/nvim/init.vim
  ln -s -v "${dotfiles_root_dir}"/.config/peco/config.json ~/.config/peco/config.json
  ln -s -v "${dotfiles_root_dir}"/.config/pip/pip.conf ~/.config/pip/pip.conf
}

# --------------------------------------
# Install Homebrew packages
# --------------------------------------
install_homebrew_packages() {
  brew bundle --global
}

# --------------------------------------
# Install Ruby packages
# --------------------------------------
install_ruby_packages() {
  local packages=("${RUBY_PACKAGES[@]}")
  local package
  local installed

  for package in "${packages[@]}"; do
    installed=$(gem list ^"${package}"$ --installed)

    if [ "${installed}" = "true" ]; then
      echo "${package} is already installed"
    else
      gem install "${package}"
    fi
  done
}

# --------------------------------------
# Install Node packages
# --------------------------------------
install_node_packages() {
  npm install
}

# --------------------------------------
# Install Python packages
# --------------------------------------
install_python2_packages() {
  pip2 install --upgrade -r requirements.txt
}

install_python3_packages() {
  pip3 install --upgrade -r requirements.txt
}

# --------------------------------------
# Do post processes
# --------------------------------------
do_post_processes() {
  echo '### ruby'
  gem update
  gem update --system
  gem cleanup
}

initialize() {
  ### Tasks not optimized
  if is_linux; then
    # diff-highlight
    sudo ln -s -v /home/linuxbrew/.linuxbrew/opt/git/share/git-core/contrib/diff-highlight/diff-highlight /usr/local/bin/

    # Warning: You have unlinked kegs in your Cellar
    # ref. https://github.com/Linuxbrew/homebrew-core/issues/7624
    brew link --overwrite util-linux
  fi
  if is_mac; then
    # diff-highlight
    ln -s /usr/local/share/git-core/contrib/diff-highlight/diff-highlight /usr/local/bin/

    # Install Homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # Install dein.vim
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh >dein_installer.sh
    sh ./dein_installer.sh ~/.cache/dein

    # Use bash version 4 in order to use READLINE_LINE in peco-select-history function
    # ref. https://rcmdnk.com/blog/2015/05/25/computer-mac-bash-zsh/
    sudo dscl . -create /Users/"$USER" UserShell /usr/local/bin/bash
    dscl . -read /Users/"$USER" UserShell

    # vagrant
    vagrant plugin update
  fi

  ### initialize Python environment
  pyenv install 2.7.15
  pyenv install 3.7.0
  pyenv global 3.7.0 2.7.15

  # TODO: Install ruby, node before installing packages
  nodenv install 10.1.0
  nodenv global 10.1.0
  rbenv install 2.5.1
}

readonly PROCNAME=${0##*/}

execute() {
  local function_name=$1
  echo "$(date '+%Y-%m-%dT%H:%M:%S') $PROCNAME $function_name start"
  eval "$1"
  echo "$(date '+%Y-%m-%dT%H:%M:%S') $PROCNAME $function_name end"
}

execute_all() {
  execute create_git_config_file
  execute create_symbolic_links
  execute install_homebrew_packages
  execute install_python2_packages
  execute install_python3_packages
  execute install_ruby_packages
  execute install_node_packages
}

usage() {
  cat <<EOF
usage: sh installer.sh <option>
option:
  a:  execute all
  g:  create .gitconfig file
  h:  install Homebrew packages
  n:  install Node packages
  p2: install Python2 packages
  p3: install Python3 packages
  r:  install Ruby packages
  s:  create symbolic links
EOF
}

### main
eval "$(cat ~/.env)"

case $1 in
  a) execute execute_all ;;
  g) execute create_git_config_file ;;
  h) execute install_homebrew_packages ;;
  n) execute install_node_packages ;;
  p2) execute install_python2_packages ;;
  p3) execute install_python3_packages ;;
  r) execute install_ruby_packages ;;
  s) execute create_symbolic_links ;;
  *)
    if [ -n "$1" ]; then
      printf "warning: Do not support '%s' option\\n\\n" "$1"
    fi
    usage
    ;;
esac
