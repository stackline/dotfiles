#!/bin/bash

# --------------------------------------
# constant
# --------------------------------------
readonly RUBY_PACKAGES=(
  mailcatcher
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
  git config --global pager.log "(diff-highlight 2>/dev/null || cat) | less"
  git config --global pager.show "(diff-highlight 2>/dev/null || cat) | less"
  git config --global pager.diff "(diff-highlight 2>/dev/null || cat) | less"

  # Customized color for diff
  # ref. https://git-scm.com/docs/git-config#git-config-colordiffltslotgt
  git config --global color.diff.meta "magenta normal"

  # Highlight whitespace
  git config --global diff.wsErrorHighlight "all"

  ### ghq
  git config --global ghq.vcs "git"
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
  mkdir ~/.bundle
  mkdir ~/.ctags.d
  mkdir ~/.composer
  mkdir ~/.config
  mkdir ~/.config/nvim
  mkdir ~/.config/pip

  ### root directory
  ln -fsv "${dotfiles_root_dir}"/.ansible-lint ~/.ansible-lint
  ln -fsv "${dotfiles_root_dir}"/.bash_profile ~/.bash_profile
  ln -fsv "${dotfiles_root_dir}"/.eslintrc.js ~/.eslintrc.js
  ln -fsv "${dotfiles_root_dir}"/.gemrc ~/.gemrc
  ln -fsv "${dotfiles_root_dir}"/.gitignore_global ~/.gitignore_global
  ln -fsv "${dotfiles_root_dir}"/.htmllintrc ~/.htmllintrc
  ln -fsv "${dotfiles_root_dir}"/.pryrc ~/.pryrc
  ln -fsv "${dotfiles_root_dir}"/.tmux.conf ~/.tmux.conf

  ### sub directory
  ln -fsv "${dotfiles_root_dir}"/.bundle/config ~/.bundle/config
  ln -fsv "${dotfiles_root_dir}"/.ctags.d/config.ctags ~/.ctags.d/config.ctags
  ln -fsv "${dotfiles_root_dir}"/.composer/composer.json ~/.composer/composer.json

  ### .config directory
  ln -fsv "${dotfiles_root_dir}"/.config/nvim/init.vim ~/.config/nvim/init.vim
  ln -fsv "${dotfiles_root_dir}"/.config/pip/pip.conf ~/.config/pip/pip.conf

  ### Homebrew's install path
  ln -fsv "$(brew --prefix)"/opt/git/share/git-core/contrib/diff-highlight/diff-highlight "$(brew --prefix)"/bin

  ### Visual Studio Code Insiders
  ln -fsv "$HOME/.ghq/github.com/stackline/dotfiles/applications/visual-studio-code-insiders/settings.json" "$HOME/Library/Application Support/Code - Insiders/User/settings.json"
}

# --------------------------------------
# Install packages
# --------------------------------------

# Manage homebrew packages with Brewfile
install_homebrew_packages() {
  brew bundle
}

# Manage node packages with package.json
install_node_packages() {
  npm install
}

# Manage python packages with requirements.txt
# Specify "--upgrade" option to upgrade pip of Python2
install_python2_packages() {
  pip2 install --upgrade -r requirements.txt
}

install_python3_packages() {
  pip3 install --upgrade -r requirements.txt
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

    # Linuxbrew
    #
    # Install Linuxbrew in "/home/linuxbrew/.linuxbrew" instead of "$HOME/.linuxbrew"
    # because pre-compiled binary bottles can only be used in "/home/linuxbrew/.linuxbrew"
    # ref. https://github.com/Linuxbrew/brew/issues/452#issuecomment-321108383
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

    # Homebrew bundle
    brew bundle

    # Warning: You have unlinked kegs in your Cellar
    # ref. https://github.com/Linuxbrew/homebrew-core/issues/7624
    brew link --overwrite util-linux
  fi
  if is_mac; then
    # Install Homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # Use bash version 4 in order to use READLINE_LINE in peco-select-history function
    # ref. https://rcmdnk.com/blog/2015/05/25/computer-mac-bash-zsh/
    sudo dscl . -create /Users/"$USER" UserShell /usr/local/bin/bash
    dscl . -read /Users/"$USER" UserShell
    # Confirm that bash version is 4.x
    echo $BASH_VERSION

    # vagrant
    vagrant plugin install vagrant-vbguest
    vagrant plugin update
  fi

  ### Install vim-plug
  ### ref. https://github.com/junegunn/vim-plug#neovim
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  ### Install SDKMAN
  ### ref. https://sdkman.io/install
  ### MEMO: Install Leiningen with Homebrew
  curl -s "https://get.sdkman.io" | bash
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  sdk install java

  ### initialize Python environment
  pyenv install 2.7.15
  # An error occurs when executing old version ansible with python 3.7
  # ref. https://github.com/ansible/ansible/issues/32816
  pyenv install 3.6.6
  pyenv global 3.6.6 2.7.15

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
