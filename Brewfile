# --------------------------------------
# Homebrew packages
# --------------------------------------
### tmux
# Patched tmux that displays a horizontal split line as single-byte characters
# ref. https://attonblog.blogspot.com/2019/08/tmux-29a.html
tap 'atton/customs'
brew 'atton/customs/tmux', args: ['HEAD']

### Manager
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
brew 'tree'
tap 'universal-ctags/universal-ctags'
# Specify the without-xml option to avoid the following errors with Linuxbrew
# Log: ./main/lxpath.h:21:26: fatal error: libxml/xpath.h: No such file or directory
brew 'universal-ctags', args: ['without-xml', 'HEAD']
brew 'wget'

### Database
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

# Linuxbrew can not install mysql@5.6 on linux
# because pidof that is depended from mysql@5.6 can not be installed on linux
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
cask 'chromium'
cask 'google-chrome'
# In November 2019, using Google Sheets with Firefox inserts unnecessary line breaks
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
cask 'iterm2'

### Viewer
cask 'adobe-acrobat-reader' # PDF Viewer
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
mas 'Xcode', id: 497799835
