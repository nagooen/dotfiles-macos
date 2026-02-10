# ~/.zshrc - Zsh configuration

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Editor
export EDITOR='vim'
export VISUAL='vim'

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# asdf
export PATH=$HOME/.asdf/shims:$PATH

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Java
if /usr/libexec/java_home &>/dev/null; then
    export JAVA_HOME=$(/usr/libexec/java_home)
    export PATH=$PATH:$JAVA_HOME/bin
fi

# Android SDK
if [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME=~/Library/Android/sdk
    export PATH=$PATH:$ANDROID_HOME/platform-tools
fi

# GPG
export GPG_TTY=$(tty)

# Starship prompt
eval "$(starship init zsh)"

# Source secrets (API tokens, etc.) - never commit this file
[[ -f ~/.secrets ]] && source ~/.secrets

# Source Zsh sub-configs
for config_file in ~/.config/zsh/*.zsh; do
    [[ -f "$config_file" ]] && source "$config_file"
done

# Mable inf-scripts
if [ -f "$HOME/projects/mableit/inf/inf-scripts/eks-jumpbox-session/eks-jumpbox-session" ]; then
    export PATH="$HOME/projects/mableit/inf/inf-scripts/eks-jumpbox-session:$PATH"
fi
if [ -f "$HOME/projects/mableit/inf/inf-scripts/switch-env/switch-env.sh" ]; then
    . "$HOME/projects/mableit/inf/inf-scripts/switch-env/switch-env.sh"
fi
if [ -f "$HOME/projects/mableit/inf/inf-scripts/prod-access/prod-access.sh" ]; then
    source "$HOME/projects/mableit/inf/inf-scripts/prod-access/prod-access.sh"
fi

# Bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Haskell (ghcup)
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

# Local overrides (machine-specific config not in version control)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
