# ~/.bashrc - Bash configuration

# Set default editor
export EDITOR='vim'
export VISUAL='vim'

# History configuration
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTCONTROL=ignoredups:ignorespace
shopt -s histappend

# Make prompt colorful
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Source aliases if exists
[[ -f ~/.aliases ]] && source ~/.aliases

# Source functions if exists
[[ -f ~/.functions ]] && source ~/.functions

# Homebrew configuration
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Enable command completion
if [ -f /opt/homebrew/etc/bash_completion ]; then
    . /opt/homebrew/etc/bash_completion
fi

# Load version managers if they exist
# asdf
[[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]] && . /opt/homebrew/opt/asdf/libexec/asdf.sh

# nvm
export NVM_DIR="$HOME/.nvm"
[[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Project-specific configurations
# Add your custom configurations below
