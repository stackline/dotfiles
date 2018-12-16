# --------------------------------------
# Homebrew packages
# --------------------------------------
### tmux
# Patched tmux that displays a horizontal split line as single-byte characters
# ref. https://attonblog.blogspot.com/2018/04/tmux-27.html
tap 'atton/customs'
brew 'atton/customs/utf8proc'
brew 'atton/customs/tmux', args: ['HEAD']

### Manager
brew 'leiningen' # Clojure build and package manager
brew 'nodenv'    # Node version manager
brew 'pyenv'     # Python version manager
brew 'pipenv'    # Python development workflow
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
brew 'composer'
brew 'ghq'
brew 'git'
# imagemagick has many dependencies.
# brew 'imagemagick'
brew 'lftp'
# gem command error
# ref. https://github.com/Homebrew/homebrew-core/issues/11636
brew 'libyaml'
brew 'mas'
brew 'neovim'
brew 'nkf'
brew 'nmap'
brew 'peco'
brew 'ripgrep'
brew 'tree'
# Specify "--without-doc" option since compilation error occurs
# error: option --no-user-cfg not recognized
tap 'universal-ctags/universal-ctags'
brew 'universal-ctags', args: ['without-doc', 'HEAD']
brew 'wget'

### Database
# Linuxbrew can not install mysql@5.6 on linux
# because pidof that is depended from mysql@5.6 can not be installed on linux
brew 'mysql@5.7'
# Using redis-cli
brew 'redis'

### required for package installation
# [Node] jpegoptim requires libjpeg version 6b or later.
# ref. https://github.com/tjko/jpegoptim#readme
brew 'jpeg'

# [Ruby] ffi
brew 'libffi'

# [Ruby] pg
# MEMO: You need to specify the path to the 'pg_config'
# ref. https://bitbucket.org/ged/ruby-pg/wiki/Home
brew 'postgresql@9.5'

# Mac OS only install below packages.
return unless /darwin/ =~ RUBY_PLATFORM

# Use bash 4.x in order to use READLINE_LINE in peco-select-history function
# ref. https://rcmdnk.com/blog/2015/05/25/computer-mac-bash-zsh/
brew 'bash'

# --------------------------------------
# Homebrew-Cask packages
# --------------------------------------
### Taps
tap 'buo/cask-upgrade'
tap 'homebrew/cask'

### Browser
cask 'google-chrome'
tap 'homebrew/cask-versions'
cask 'google-chrome-canary'

### SQL Client
# cask 'postico'
# cask 'sequel-pro'
cask 'sequel-pro-nightly'
# cask 'teamsql'
cask 'tableplus'

### FTP Client
cask 'cyberduck'

### Terminal emulator
cask 'iterm2'

### Editor
# cask 'rubymine'
cask 'visual-studio-code'

### Development environment
cask 'docker'
cask 'vagrant'
# MEMO: Need to allow applications downloaded from Oracle
# ref. https://qiita.com/nemui-fujiu/items/231971609762a6562af3
cask 'virtualbox'

### Utility
cask 'dropbox'
cask 'google-japanese-ime'
cask 'grammarly'
cask 'hyperswitch'
cask 'imageoptim'
cask 'postman'
cask 'skitch'
cask 'slack'
cask 'spectacle' # Resize windows
# cask 'gyazo'
# cask 'java'
# cask 'licecap'
# cask 'paintbrush'
# cask 'toyviewer'

# --------------------------------------
# Mac App Store
# --------------------------------------
# To use the iOS simulator
mas 'Xcode', id: 497799835
