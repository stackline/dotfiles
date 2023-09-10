# frozen_string_literal: true

# --------------------------------------
# Homebrew packages
# --------------------------------------

### Compiler
# [Linux]
# GCC and glibc are used in the basic part of linuxbrew.
# If it is deleted, an error occurs during package installation
# or application execution.
brew 'gcc' if RUBY_PLATFORM.include?('linux')

# [macOS]
# Use with AtCoder.
brew 'gcc@9'

# [macOS]
# Use clangd with LSP service.
# Put below compile_flags.txt to the repository root directory, if you need to include "bits/stdc++.h".
#
#   $ echo "-I${HOMEBREW_PREFIX}/include" > compile_flags.txt
#
brew 'llvm' if /darwin/ =~ RUBY_PLATFORM

### Manager
# NOTE: Use multiple Go versions with Homebrew.
#
# * After adding goenv path to $PATH, exporting to $PATH is sometimes slow.
# * Fix Go version of Homebrew with "$ brew pin".
# * Install multiple Go versions by referring to the following articles.
#   * ref. https://golang.org/doc/manage-install#installing-multiple
#
brew 'go'
brew 'nodenv'    # Node version manager
brew 'pyenv'     # Python version manager
brew 'pipenv'    # Python development workflow
brew 'rbenv'     # Ruby version manager
brew 'tfenv'     # Terraform version manager
tap 'sdkman/tap'
brew 'sdkman-cli' # Java SDK manager

### Go package
# $ go install github.com/rhysd/vim-startuptime@latest
# $ go install github.com/stackline/mydate
# $ go install golang.org/x/tools/gopls@latest

### Development tools
brew 'bash-language-server' # Bash: LSP server
brew 'hadolint'             # Dockerfile: Linter
brew 'gopls'                # Go: LSP server
brew 'staticcheck'          # Go: Linter
brew 'lua-language-server'  # Lua: LSP server
brew 'shellcheck'           # Shell script: Linter
brew 'shfmt'                # Shell script: Formatter
brew 'terraform-ls'         # Terraform: LSP server
# TODO: Consider how to manage npm packages.
# npm install -g vim-language-server Vim Script: LSP server
brew 'vint'                 # Vim script: Linter
brew 'yaml-language-server' # Yaml: LSP server
brew 'yamllint'             # Yaml: Linter

### Bash completion
brew 'bash-completion@2'
brew 'gem-completion'

### Utility
# [macOS]
# $ echo "${HOMEBREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells
# $ chsh -s "${HOMEBREW_PREFIX}/bin/bash"
brew 'bash'
brew 'bat' # alternative to cat
brew 'bats-core' # Testing framework for Bash
brew 'fd'
brew 'fzf'
brew 'gh'
brew 'ghq'
brew 'git'
# imagemagick has many dependencies.
# brew 'imagemagick'
brew 'jq' # Command-line JSON processor
brew 'neovim'
brew 'nkf'
brew 'nmap'
brew 'silicon'
brew 'ripgrep'
brew 'macos-trash' # Move files to the trash
# TODO: See if I can use Zellij instead of tmux as a terminal multiplexer.
# brew 'zellij'
brew 'tmux'
brew 'tree'
brew 'universal-ctags'
brew 'wget'
brew 'xdg-ninja'

if RUBY_PLATFORM.include?('linux')
  # If you do not have this package when installing ruby via rbenv,
  # the following error will occur.
  #
  #   configure: error: gettimeofday() must exist
  #
  brew 'linux-headers'
end

# Mac OS only install below packages.
return unless /darwin/ =~ RUBY_PLATFORM

# --------------------------------------
# Homebrew-Cask packages
# --------------------------------------
### Taps
tap 'homebrew/cask'

### Browser
cask 'firefox'
cask 'google-chrome'

### Client
cask 'cyberduck' # FTP client
cask 'insomnia'  # API client for REST and GraphQL
cask 'tableplus' # SQL client
cask 'beekeeper-studio' # SQL client

### Communication tool
cask 'slack'
cask 'zoom'

### Editor, IDE
cask 'visual-studio-code'
cask 'eclipse-java'
cask 'processing'

### Input method
cask 'google-japanese-ime'

### Terminal emulator
cask 'wezterm'

### Viewer
cask 'adobe-acrobat-reader' # PDF viewer
cask 'kindle' # Kindle books Viewer

### Development environment
cask 'android-studio'
cask 'docker'
brew 'docker-compose'

### Utility
cask 'alttab'
cask 'imageoptim'
cask 'notion'
cask 'skitch'
cask '1password' # Password manager
