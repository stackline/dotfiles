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
  ln -fsv "${dotfiles_root_dir}"/.bash_profile ~/.bash_profile
  ln -fsv "${dotfiles_root_dir}"/.bashrc ~/.bashrc
  # TODO: Consider adding an include path to gcc and llvm
  # Make the directory "${HOMEBREW_PREFIX}/include/bits" as needed.
  ln -fsv "${dotfiles_root_dir}"/include/bits/stdc++.h "${HOMEBREW_PREFIX}"/include/bits/stdc++.h

  ### Directories
  ln -fnsv "${dotfiles_root_dir}"/.config ~/.config

  ### Homebrew's install path
  ln -fsv "${HOMEBREW_PREFIX}"/opt/git/share/git-core/contrib/diff-highlight/diff-highlight "${HOMEBREW_PREFIX}"/bin
}

# --------------------------------------
# Install packages
# --------------------------------------

readonly PROCNAME=${0##*/}

execute() {
  local function_name=$1
  echo "$(date '+%Y-%m-%dT%H:%M:%S') $PROCNAME $function_name start"
  eval "$1"
  echo "$(date '+%Y-%m-%dT%H:%M:%S') $PROCNAME $function_name end"
}

execute create_symbolic_links
