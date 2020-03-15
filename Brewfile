# frozen_string_literal: true

# --------------------------------------
# Homebrew packages
# --------------------------------------
### Manager
brew 'nodenv'    # Node version manager
brew 'pyenv'     # Python version manager
brew 'pipenv'    # Python development workflow
# Build development environments with Docker containers
# because build error occurs when installing Ruby 2.3 or less.
#
# * Ruby 2.3 does not support openssl 1.1
# * ref. https://github.com/rbenv/ruby-build/issues/1207#issuecomment-399744332
# * ref. https://github.com/rbenv/ruby-build/issues/1353
#
# Build error occurs when installing OpenSSL 1.0 with the following formula.
#
# * https://github.com/rbenv/homebrew-tap
#
brew 'rbenv'     # Ruby version manager
brew 'tfenv'     # Terraform version manager

### Linter
# Dockerfile
brew 'hadolint'
# Shell script
brew 'shellcheck'
brew 'shfmt'

### Bash completion
brew 'bash-completion'
brew 'gem-completion'

### Utility
brew 'bats-core' # Testing framework for Bash
brew 'composer'
brew 'coreutils' if OS.mac?
brew 'fd'
brew 'fzf'
brew 'ghq'
brew 'git'
# imagemagick has many dependencies.
# brew 'imagemagick'
brew 'jq' # Command-line JSON processor
brew 'lftp'
# gem command error
# ref. https://github.com/Homebrew/homebrew-core/issues/11636
brew 'libyaml'
brew 'neovim'
brew 'nkf'
brew 'nmap'
brew 'peco'
brew 'ripgrep'
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

# [Ruby] pg
# MEMO: You need to specify the path to the 'pg_config'
# ref. https://bitbucket.org/ged/ruby-pg/wiki/Home
brew 'postgresql@9.5'

# For PostgreSQL 12 psql command
brew 'libpq'

if RUBY_PLATFORM.include?('linux')
  # If you do not have this package when installing ruby via rbenv,
  # the following error will occur.
  #
  #   configure: error: gettimeofday() must exist
  #
  brew 'linux-headers'

  # GCC and glibc are used in the basic part of linuxbrew.
  # If it is deleted, an error occurs during package installation
  # or application execution.
  brew 'gcc'

  # docker formula do not have two files for systemd.
  # So, we use a yum package.
  # ref. http://docs.docker.jp/engine/articles/systemd.html#systemd
  # brew 'docker'
  brew 'docker-compose'
end

# Mac OS only install below packages.
return unless /darwin/ =~ RUBY_PLATFORM

# Linuxbrew can not install mysql@5.6 on linux
# because pidof that is depended from mysql@5.6 can not be installed on linux
# Linuxbrew can not install mariadb@10.3 on linux
brew 'mysql@5.7'

# Use bash 4.x in order to use READLINE_LINE in peco-select-history function
# ref. https://rcmdnk.com/blog/2015/05/25/computer-mac-bash-zsh/
brew 'bash'

# Mac App Store command line interface
brew 'mas'

# --------------------------------------
# Homebrew-Cask packages
# --------------------------------------
### Taps
tap 'buo/cask-upgrade'
tap 'homebrew/cask'
tap 'homebrew/cask-fonts' # for font-source-han-code-jp

### Browser
# cask 'chromium'
cask 'google-chrome'
# Using Google Sheets with Firefox inserts unnecessary line breaks
# ref. https://support.google.com/docs/thread/18235069?hl=en
# cask 'firefox'

### Client
cask 'cyberduck'          # FTP client
cask 'insomnia'           # Rest client
cask 'tableplus'          # SQL client

### Communication tool
cask 'slack'
cask 'zoomus'

### Editor
cask 'visual-studio-code'

### Terminal emulator
# cask 'alacritty'
cask 'hyper'
# When starting nvim with iterm2, unintentional input is sometimes done.
# However, iterm2 + tmux's copy mode is useful when copying long texts
# that require scrolling.
cask 'iterm2'

### Viewer
cask 'kindle' # Kindle books Viewer

### Development environment
cask 'docker'
cask 'vagrant'
# MEMO: Need to allow applications downloaded from Oracle
# ref. https://qiita.com/nemui-fujiu/items/231971609762a6562af3
cask 'virtualbox'

### Utility
cask 'dropbox'
cask 'font-source-han-code-jp'
cask 'google-japanese-ime'
cask 'hyperswitch'
cask 'imageoptim'
cask 'skitch'
# cask 'java'
# cask 'licecap'

# --------------------------------------
# Mac App Store
# --------------------------------------
# To use the iOS simulator
mas 'Xcode', id: 497_799_835
