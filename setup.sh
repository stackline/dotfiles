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

  ### Directories
  ln -fnsv "${dotfiles_root_dir}"/.config ~/.config

  ### Homebrew's install path
  ln -fsv "${HOMEBREW_PREFIX}"/opt/git/share/git-core/contrib/diff-highlight/diff-highlight "${HOMEBREW_PREFIX}"/bin
}

# --------------------------------------
# Configure Docker
# --------------------------------------
configure_docker() {
  local config_dir="${HOME}/.config/docker"
  local config_file="${config_dir}/config.json"

  mkdir -p "${config_dir}"

  if [ ! -f "${config_file}" ]; then
    echo '{}' > "${config_file}"
  fi

  local tmp
  tmp=$(mktemp)
  # Change the detach key from the default ctrl-p,ctrl-q to ctrl-\.
  # The default conflicts with ctrl-p (previous command history) inside containers.
  jq '.detachKeys = "ctrl-\\"' "${config_file}" > "${tmp}" && mv "${tmp}" "${config_file}"
  echo "Docker: detachKeys set to ctrl-\\"
}

# --------------------------------------
# Configure Hammerspoon
# --------------------------------------
configure_hammerspoon() {
  # Hammerspoon ignores XDG_CONFIG_HOME even when it is exported, so the config
  # path has to be set explicitly through the MJConfigFile user default.
  # https://github.com/Hammerspoon/hammerspoon/issues/2175
  #
  # shellcheck disable=SC2088 # Hammerspoon expands the tilde, so the literal
  # tilde is intended here. It keeps the user name out of the stored value.
  defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
  echo "Hammerspoon: MJConfigFile set to ~/.config/hammerspoon/init.lua"
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
execute configure_docker
execute configure_hammerspoon
