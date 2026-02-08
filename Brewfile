# frozen_string_literal: true

# --------------------------------------
# Homebrew packages
# --------------------------------------

### Compiler
# Use with AtCoder.
brew 'gcc@9'

# Use clangd with LSP service.
# Put below compile_flags.txt to the repository root directory, if you need to include "bits/stdc++.h".
#
#   $ echo "-I${HOMEBREW_PREFIX}/include" > compile_flags.txt
#
brew 'llvm'

### Manager
brew 'goenv'     # Go version manager
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
brew 'hadolint'             # Dockerfile: Linter
brew 'staticcheck'          # Go: Linter
brew 'shellcheck'           # Shell script: Linter
brew 'shfmt'                # Shell script: Formatter
brew 'vint'                 # Vim script: Linter
brew 'yamllint'             # Yaml: Linter
brew 'google-cloud-sdk'

### Bash completion
brew 'bash-completion@2'
brew 'gem-completion'

### Utility
# $ echo "${HOMEBREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells
# $ chsh -s "${HOMEBREW_PREFIX}/bin/bash"
brew 'bash'
brew 'bat' # alternative to cat
brew 'bats-core' # Testing framework for Bash
brew 'direnv'
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

# --------------------------------------
# Homebrew Cask packages
# --------------------------------------
### taps
tap 'homebrew/cask'

### browsers
cask 'firefox'              # web browser
cask 'google-chrome'        # web browser
cask 'adobe-acrobat-reader' # pdf viewer
cask 'kindle'               # kindle books viewer

### collaboration tools
cask 'notion'
cask 'slack'
cask 'zoom'

### development tools
# GraphiQL is good enough as a graphql client.
cask 'ghostty'            # terminal emulator
caks 'claude-code'        # ai coding assistant
cask 'cursor'             # code editor
cask 'visual-studio-code' # code editor
cask 'android-studio'     # android app IDE
cask 'beekeeper-studio'   # sql client
cask 'tableplus'          # sql client
cask 'cyberduck'          # ftp client
cask 'docker'             # container management tool
cask 'rancher'            # container management tool (cli plugins is installed in "~/.docker/cli-plugins".)

### utilities
cask 'contexts'   # window switcher
cask 'imageoptim' # image compressor
cask '1password'  # password manager
