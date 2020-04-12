#!/bin/bash

# --------------------------------------
# Utilities
# --------------------------------------
is_mac() {
  [ "$(uname)" = "Darwin" ] && return 0
  return 1
}

is_linux() {
  [ "$(uname)" = "Linux" ] && return 0
  return 1
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

  ### Files
  ln -fsv "${dotfiles_root_dir}"/.ansible-lint ~/.ansible-lint
  ln -fsv "${dotfiles_root_dir}"/.bashrc ~/.bashrc
  ln -fsv "${dotfiles_root_dir}"/.bashrc ~/.zshrc # Share config file with Bash
  ln -fsv "${dotfiles_root_dir}"/.eslintrc.js ~/.eslintrc.js
  ln -fsv "${dotfiles_root_dir}"/.gemrc ~/.gemrc
  ln -fsv "${dotfiles_root_dir}"/.htmllintrc ~/.htmllintrc
  ln -fsv "${dotfiles_root_dir}"/.pryrc ~/.pryrc
  ln -fsv "${dotfiles_root_dir}"/.tmux.conf ~/.tmux.conf

  ### Directories
  ln -fnsv "${dotfiles_root_dir}"/.composer ~/.composer
  ln -fnsv "${dotfiles_root_dir}"/.config ~/.config
  ln -fnsv "${dotfiles_root_dir}"/.docker ~/.docker

  ### Homebrew's install path
  ln -fsv "$(brew --prefix)"/opt/git/share/git-core/contrib/diff-highlight/diff-highlight "$(brew --prefix)"/bin
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

initialize() {
  ### Tasks not optimized
  if is_linux; then

    # Linuxbrew
    #
    # Install Linuxbrew in "/home/linuxbrew/.linuxbrew" instead of "$HOME/.linuxbrew"
    # because pre-compiled binary bottles can only be used in "/home/linuxbrew/.linuxbrew"
    # ref. https://github.com/Linuxbrew/brew/issues/452#issuecomment-321108383
    #
    export HOMEBREW_FORCE_VENDOR_RUBY=1 # Use portable ruby
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

    # Homebrew bundle
    brew bundle -v

    # If you do not have this setting when installing ruby via rbenv,
    # the following error will occur.
    #
    #   The Ruby openssl extension was not compiled.
    #   ERROR: Ruby install aborted due to missing extensions
    #   Try running `yum install -y openssl-devel` to fetch missing dependencies.
    #
    brew link openssl@1.1 --force
  fi
  if is_mac; then
    # Install Homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # Use bash version 4 in order to use READLINE_LINE in peco-select-history function
    # ref. https://rcmdnk.com/blog/2015/05/25/computer-mac-bash-zsh/
    sudo dscl . -create /Users/"$USER" UserShell /usr/local/bin/bash
    dscl . -read /Users/"$USER" UserShell
    # Confirm that bash version is 4.x
    echo "$BASH_VERSION"

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
  execute create_symbolic_links
  execute install_homebrew_packages
  execute install_python2_packages
  execute install_python3_packages
  execute install_node_packages
}

usage() {
  cat <<EOF
usage: sh installer.sh <option>
option:
  a:  execute all
  h:  install Homebrew packages
  n:  install Node packages
  p2: install Python2 packages
  p3: install Python3 packages
  s:  create symbolic links
EOF
}

### main
eval "$(cat ~/.env)"

case $1 in
  a) execute execute_all ;;
  h) execute install_homebrew_packages ;;
  n) execute install_node_packages ;;
  p2) execute install_python2_packages ;;
  p3) execute install_python3_packages ;;
  s) execute create_symbolic_links ;;
  *)
    if [ -n "$1" ]; then
      printf "warning: Do not support '%s' option\\n\\n" "$1"
    fi
    usage
    ;;
esac
