# ~/.zshrc - Zsh configuration

# Path to your oh-my-zsh installation (if using)
# export ZSH="$HOME/.oh-my-zsh"

# Set default editor
export EDITOR='vim'
export VISUAL='vim'

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Colorful prompt
autoload -U colors && colors
PS1="%{$fg[cyan]%}%n@%m%{$reset_color%}:%{$fg[green]%}%~%{$reset_color%}$ "

# Source aliases if exists
[[ -f ~/.aliases ]] && source ~/.aliases

# Source functions if exists
[[ -f ~/.functions ]] && source ~/.functions

# Homebrew configuration
if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Enable command completion
autoload -Uz compinit && compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

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
