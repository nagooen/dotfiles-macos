# Zsh aliases

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# List directory contents
alias ls='ls -G'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias glog='git log --oneline --graph --decorate'

# Homebrew
alias brewup='brew update && brew upgrade && brew cleanup'

# System
alias reload='source ~/.zshrc'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Editor
alias v='vim'

# Network
alias myip='curl ifconfig.me'
alias localip='ipconfig getifaddr en0'

# Finder
alias o='open . &'

# Docker
alias dps='docker ps'
alias dimg='docker images'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dpsa='docker ps -a'
alias dim='docker images'
alias dsp='docker system prune --all'

# GitHub CLI account switching
alias gh-who='gh api user --jq .login'
