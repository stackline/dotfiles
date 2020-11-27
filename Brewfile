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

# [Linux]
# NOTE: Using gcc@9 to build sassc gem ad hoc.
#
# ### Background
#
# The version of Linuxbrew's gcc package is 5.5.0.
# Error when building sassc gem 2.2.1 with GCC 5.5.0.
# Need to build sassc 2.2.1 with more recent version of GCC.
#
# * https://github.com/sass/sassc-ruby/issues/149#issuecomment-552517260
#
# ### How to build ad hoc
#
# ```
# $ brew install gcc
# $ bundle install # with gcc 5.5 (Sassc build fails at this point)
#
# $ brew unlink gcc
# $ brew install gcc@9
# $ bundle install # with gcc 9.2 (Sassc build success)
#
# $ brew link gcc # If unlinked, "cannot open shared object file" error occurs when executing rails s.
# $ bin/rails s
# ```
#
# [macOS]
# Use with AtCoder.
brew 'gcc@9'

# [macOS]
# Use clangd with coc.nvim + coc-clangd.
# Put below compile_flags.txt to the repository root directory, if you need to include "bits/stdc++.h".
#
# ```
# $ echo "-I/usr/local/include" > compile_flags.txt
# ```
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
# NOTE: There is no SDKMAN Homebrew formula, so install it manually.
#
# 1. Install SDKMAN while referring to the official manual.
#    ref. https://sdkman.io/install
# 2. Add settings to .config/bash/sdkman.sh
#
# brew 'sdkman'

### Linter
# Dockerfile
brew 'hadolint'
# Shell script
brew 'shellcheck'
brew 'shfmt'

### Bash completion
brew 'bash-completion@2'
brew 'gem-completion'

### Utility
# [macOS]
# $ echo '/usr/local/bin/bash' | sudo tee -a /etc/shells
# $ chsh -s /usr/local/bin/bash
brew 'bash'
brew 'bat' # alternative to cat
brew 'bats-core' # Testing framework for Bash
brew 'fd'
brew 'fzf'
brew 'ghq'
brew 'git'
# imagemagick has many dependencies.
# brew 'imagemagick'
brew 'jq' # Command-line JSON processor
brew 'neovim'
brew 'nkf'
brew 'nmap'
brew 'ripgrep'
brew 'tig' # Text-mode interface for git
# Be careful when using tmux with Terminal.app
# ref. https://attonblog.blogspot.com/2017/11/tmux-pull-request.html
brew 'tmux'
brew 'tree'
tap 'universal-ctags/universal-ctags'
# Specify the without-xml option to avoid the following errors with Linuxbrew
#
#   ./main/lxpath.h:21:26:
#   fatal error: libxml/xpath.h: No such file or directory
#
brew 'universal-ctags', args: %w[without-xml HEAD]
brew 'wget'

### Database
# Using redis-cli
brew 'redis'

### required for installation
# [Node] jpegoptim requires libjpeg version 6b or later.
# ref. https://github.com/tjko/jpegoptim#readme
brew 'jpeg'

# [Ruby] ffi
brew 'libffi'

# [Ruby] pg gem
# NOTE: You need to specify the path to the 'pg_config' in the '.env' file.
#       ref. https://bitbucket.org/ged/ruby-pg/wiki/Home
brew 'libpq'          # pg_config for PostgreSQL 12.x

if RUBY_PLATFORM.include?('linux')
  # If you do not have this package when installing ruby via rbenv,
  # the following error will occur.
  #
  #   configure: error: gettimeofday() must exist
  #
  brew 'linux-headers'

  # docker formula do not have two files for systemd.
  # So, we use a yum package.
  # ref. http://docs.docker.jp/engine/articles/systemd.html#systemd
  # brew 'docker'
  brew 'docker-compose'
end

# Mac OS only install below packages.
return unless /darwin/ =~ RUBY_PLATFORM

# Mac App Store command line interface
brew 'mas'

# --------------------------------------
# Homebrew-Cask packages
# --------------------------------------
### Taps
tap 'buo/cask-upgrade'
tap 'homebrew/cask'

### Browser
cask 'firefox'
cask 'google-chrome'

### Client
cask 'cyberduck' # FTP client
cask 'insomnia'  # API client for REST and GraphQL
cask 'tableplus' # SQL client

### Communication tool
cask 'slack'
cask 'zoomus'

### Editor
cask 'visual-studio-code'

### Input method
cask 'google-japanese-ime'

### Terminal emulator
cask 'iterm2'

### Viewer
cask 'kindle' # Kindle books Viewer

### Development environment
cask 'android-studio'
cask 'docker'
cask 'vagrant'
# MEMO: Need to allow applications downloaded from Oracle
# ref. https://qiita.com/nemui-fujiu/items/231971609762a6562af3
cask 'virtualbox'

### Utility
cask 'dropbox'
cask 'hyperswitch'
cask 'imageoptim'
cask 'skitch'
cask 'spotify'

# --------------------------------------
# Mac App Store
# --------------------------------------
# To use the iOS simulator
mas 'Xcode', id: 497_799_835
