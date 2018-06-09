#!/bin/bash


readonly GIT_USER_NAME=""
readonly GIT_USER_EMAIL=""


# --------------------------------------
# constant
# --------------------------------------
readonly HOMEBREW_PACKAGES=(
  ### Version manager
  nodenv # Node
  rbenv  # Ruby
  tfenv  # Terraform

  ### pip
  python
  python@2

  ### Command-line completion
  bash-completion
  gem-completion

  ### Git
  git
  ghq

  ### Database
  mysql
  redis # redis-cli

  ### Linter
  shellcheck # Shell script
  hadolint   # Dockerfile

  ### Utility
  nkf
  nmap
  tree
  wget

  ### Middleware
  # imagemagick # MEMO: Many dependencies
  colordiff
  composer
  lftp
  neovim
  peco
  ripgrep

  ### required for package installation
  libjpeg # jpegoptim (Node)
  libpng  # pngquant (Node)
  libffi  # ffi (Gem)

  # MEMO: You need to specify the path to the 'pg_config'
  # ref. https://bitbucket.org/ged/ruby-pg/wiki/Home
  postgresql@9.5 # pg (gem)

  ### gem command error
  # ref. https://github.com/Homebrew/homebrew-core/issues/11636
  libyaml
)

readonly NODE_PACKAGES=(
  eslint
  htmllint
)

readonly PYTHON2_PACKAGES=(
  # MEMO: If an error that python can't be found occuers,
  # you need to reinstall Ansible-lint.
  ansible-lint
  pip
)

readonly PYTHON3_PACKAGES=(
  neovim # required for deoplete (Vim plugin)
)

readonly RUBY_PACKAGES=(
  mailcatcher
  neovim # required for deoplete-ruby
  rubocop
  rubocop-rspec
  slim_lint
  solargraph
)

# --------------------------------------
# utilities
# --------------------------------------
heading() {
  echo ''
  echo '# --------------------------------------'
  echo "# ${1}"
  echo '# --------------------------------------'
}

is_mac() {
  [ "$(uname)" == "Darwin" ] && return 0
  return 1
}

is_linux() {
  [ "$(uname)" == "Linux" ] && return 0
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
  ln -s -v "${dotfiles_root_dir}"/.gemrc ~/.gemrc
  ln -s -v "${dotfiles_root_dir}"/.gitconfig ~/.gitconfig
  ln -s -v "${dotfiles_root_dir}"/.gitignore_global ~/.gitignore_global
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
# Arguments:
#   Package name array
# --------------------------------------
install_homebrew_packages() {
  local packages=("$@")
  local package
  local version

  for package in "${packages[@]}"; do
    version=$(brew ls --versions "${package}")

    if [ "${version}" ]; then
      echo "${package} is already installed"
    else
      brew install "${package}"
    fi
  done
}

# --------------------------------------
# Install Ruby packages
# Arguments:
#   Package name array
# --------------------------------------
install_ruby_packages() {
  local packages=("$@")
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
# Arguments:
#   Package name array
# --------------------------------------
install_node_packages() {
  local packages=("$@")
  local package
  local not_installed

  for package in "${packages[@]}"; do
    not_installed=$(npm ls -g "${package}" | grep '(empty)')

    if [ -z "${not_installed}" ]; then
      echo "${package} is already installed"
    else
      npm install -g "${package}"
    fi
  done
}

# --------------------------------------
# Install Python packages
# Arguments:
#   Package name array
# --------------------------------------
install_python2_packages() {
  local packages=("$@")
  local package
  local version

  for package in "${packages[@]}"; do
    version=$(pip show "${package}" | grep Version)

    if [ "${version}" ]; then
      echo "${package} is already installed"
    else
      pip install --upgrade "${package}"
    fi
  done
}

# --------------------------------------
# Install Python packages
# Arguments:
#   Package name array
# --------------------------------------
install_python3_packages() {
  local packages=("$@")
  local package
  local version

  for package in "${packages[@]}"; do
    version=$(pip3 show "${package}" | grep Version)

    if [ "${version}" ]; then
      echo "${package} is already installed"
    else
      pip3 install --upgrade "${package}"
    fi
  done
}

# --------------------------------------
# Do post processes
# --------------------------------------
do_post_processes() {
  echo '### homebrew'
  brew upgrade --cleanup
  brew prune --dry-run
  # MEMO: brew cleanup is slow
  brew cleanup
  brew doctor

  echo '### node'
  npm update -g

  echo '### ruby'
  gem update
  gem update --system
  gem cleanup
}

# --------------------------------------
# Main routine
# --------------------------------------
main() {
  heading 'create symbolic links'
  create_symbolic_links

  heading 'install homebrew packages'
  install_homebrew_packages "${HOMEBREW_PACKAGES[@]}"

  heading 'install python2 packages'
  install_python2_packages "${PYTHON2_PACKAGES[@]}"

  heading 'install python3 packages'
  install_python3_packages "${PYTHON3_PACKAGES[@]}"

  heading 'install ruby packages'
  install_ruby_packages "${RUBY_PACKAGES[@]}"

  heading 'install node packages'
  install_node_packages "${NODE_PACKAGES[@]}"

  heading 'do post processes'
  do_post_processes
}
main

initialize() {
  ### Tasks not optimized
  if is_linux; then
    # diff-highlight
    sudo ln -s -v /home/linuxbrew/.linuxbrew/opt/git/share/git-core/contrib/diff-highlight/diff-highlight /usr/local/bin/

    # Warning: You have unlinked kegs in your Cellar
    # ref. https://github.com/Linuxbrew/homebrew-core/issues/7624
    brew link --overwrite util-linux

    # Patched tmux that displays a horizontal split line as single-byte characters
    # ref. https://attonblog.blogspot.com/2018/04/tmux-27.html
    brew tap atton/customs
    brew install atton/customs/utf8proc
    brew install --HEAD atton/customs/tmux
  fi
  if is_mac; then
    # diff-highlight
    ln -s /usr/local/share/git-core/contrib/diff-highlight/diff-highlight /usr/local/bin/

    # Install Homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    # Install dein.vim
    curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > dein_installer.sh
    sh ./dein_installer.sh ~/.cache/dein

    # Homebrew-Cask
    brew cask cleanup
    brew cask doctor

    # vagrant
    vagrant plugin update
  fi

  pip install ansible==2.3.2

  # TODO: Install ruby, node before installing packages
  nodenv install 10.1.0
  nodenv global 10.1.0
  rbenv install 2.5.1

  arg=$1
  if [ "$arg" ]; then
    [ "$GIT_USER_NAME" ]  && git config --global user.name  "$GIT_USER_NAME"
    [ "$GIT_USER_EMAIL" ] && git config --global user.email "$GIT_USER_EMAIL"
  fi
}
# miscellaneous_task

if is_mac; then
  brew cask install slack

  ### Browser
  brew cask install google-chrome
  brew cask install google-chrome-canary

  ### SQL Client
  brew cask install tableplus
  brew cask install sequel-pro
  # brew cask install postico

  ### FTP Client
  brew cask install cyberduck

  ### Editor
  brew cask install visual-studio-code
  # brew cask install atom
  # brew cask install rubymine

  ### Development
  brew cask install docker
  brew cask install vagrant
  brew cask install virtualbox

  ### Utility
  brew cask install dropbox
  brew cask install google-japanese-ime
  brew cask install hyperswitch
  brew cask install imageoptim

  # dropbox
  # gyazo
  # java
  # licecap
  # paintbrush
  # postman
  # skitch
  # toyviewer
fi

