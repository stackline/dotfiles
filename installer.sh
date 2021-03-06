#!/bin/bash

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
  ln -fsv "${dotfiles_root_dir}"/.bash_profile ~/.bash_profile
  ln -fsv "${dotfiles_root_dir}"/.bashrc ~/.bashrc
  ln -fsv "${dotfiles_root_dir}"/.gemrc ~/.gemrc
  # TODO: Consider adding an include path to gcc and llvm
  # Make the directory "/usr/local/include/bits" as needed.
  ln -fsv "${dotfiles_root_dir}"/include/bits/stdc++.h /usr/local/include/bits/stdc++.h

  ### Directories
  ln -fnsv "${dotfiles_root_dir}"/.config ~/.config

  ### Homebrew's install path
  ln -fsv "$(brew --prefix)"/opt/git/share/git-core/contrib/diff-highlight/diff-highlight "$(brew --prefix)"/bin
}

# --------------------------------------
# Install packages
# --------------------------------------

# Manage python packages with requirements.txt
# Specify "--upgrade" option to upgrade pip of Python2
install_python2_packages() {
  pip2 install --upgrade -r requirements.txt
}

install_python3_packages() {
  pip3 install --upgrade -r requirements.txt
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
  execute install_python2_packages
  execute install_python3_packages
}

usage() {
  cat <<EOF
usage: sh installer.sh <option>
option:
  a:  execute all
  p2: install Python2 packages
  p3: install Python3 packages
  s:  create symbolic links
EOF
}

### main
eval "$(cat ~/.env)"

case $1 in
  a) execute execute_all ;;
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
