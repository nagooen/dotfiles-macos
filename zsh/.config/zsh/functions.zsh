# Zsh functions

# Create a new directory and enter it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract any archive type
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find a file with a pattern in name
ff() {
    find . -type f -iname "*$1*"
}

# Show disk usage for current directory
diskusage() {
    du -sh * | sort -h
}

# Quick HTTP server
serve() {
    local port="${1:-8000}"
    python3 -m http.server "$port"
}

# Create a backup of a file
backup() {
    cp "$1"{,.bak}
}

# Get weather
weather() {
    local city="${1:-}"
    curl "wttr.in/${city}"
}

# Display PATH as numbered list
path() {
    echo $PATH | tr ":" "\n" | nl
}

# Reload shell config
src() {
    source ~/.zshrc
}

# Checkout default branch (main/master) with optional pull
gcom() {
    local do_pull=0

    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        printf "%s\n" "Usage: gcom [-p]
Switch to the default Git branch (main or master), with optional pull.

Options:
  -p          Pull latest changes after switching
  -h, --help  Show this help message"
        return 0
    fi

    if [[ "$1" == "-p" ]]; then
        do_pull=1
    fi

    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Not a git repository."
        return 1
    fi

    # Fetch from remote if available
    if git remote | grep -q "^origin$"; then
        git fetch origin > /dev/null 2>&1
    fi

    # Determine default branch
    local default_branch=""
    if git remote | grep -q "^origin$"; then
        default_branch=$(git remote show origin 2>/dev/null | awk '/HEAD branch/ { print $NF }')
    fi
    if [[ -z "$default_branch" ]]; then
        if git show-ref --quiet refs/heads/main; then
            default_branch="main"
        elif git show-ref --quiet refs/heads/master; then
            default_branch="master"
        else
            echo "Could not determine default branch."
            return 1
        fi
    fi

    echo "Switching to $default_branch"
    git checkout "$default_branch" || return 1

    if [[ $do_pull -eq 1 ]]; then
        echo "Pulling latest changes..."
        git pull || return 1
    fi
}

# Push current branch to origin with upstream tracking
gpum() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Not a git repository."
        return 1
    fi

    local current_branch=$(git branch --show-current)
    if [[ -z "$current_branch" ]]; then
        echo "Could not determine current branch."
        return 1
    fi

    if ! git remote | grep -q "^origin$"; then
        echo "No 'origin' remote found."
        return 1
    fi

    echo "Pushing $current_branch to origin with upstream tracking..."
    git push -u origin "$current_branch" || return 1
}

# Rebase current branch against default branch
grbm() {
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Not a git repository."
        return 1
    fi

    local current_branch=$(git branch --show-current)
    if [[ -z "$current_branch" ]]; then
        echo "Could not determine current branch."
        return 1
    fi

    # Fetch latest
    if git remote | grep -q "^origin$"; then
        echo "Fetching latest from origin..."
        git fetch origin > /dev/null 2>&1
    fi

    # Determine default branch
    local default_branch=""
    if git remote | grep -q "^origin$"; then
        default_branch=$(git remote show origin 2>/dev/null | awk '/HEAD branch/ { print $NF }')
    fi
    if [[ -z "$default_branch" ]]; then
        if git show-ref --quiet refs/heads/main; then
            default_branch="main"
        elif git show-ref --quiet refs/heads/master; then
            default_branch="master"
        else
            echo "Could not determine default branch."
            return 1
        fi
    fi

    if [[ "$current_branch" == "$default_branch" ]]; then
        echo "Already on default branch ($default_branch). Nothing to rebase."
        return 0
    fi

    echo "Rebasing $current_branch against $default_branch..."
    git rebase "origin/$default_branch" || {
        echo "Rebase failed. You may need to resolve conflicts manually."
        return 1
    }

    echo "Successfully rebased $current_branch against $default_branch"
}

# Remove merged branches
gbrm() {
    local default_branch=""
    if git remote | grep -q "^origin$"; then
        default_branch=$(git remote show origin 2>/dev/null | awk '/HEAD branch/ { print $NF }')
    fi
    if [[ -z "$default_branch" ]]; then
        default_branch="main"
    fi

    git branch --merged "$default_branch" | grep -v "^\*" | grep -v "$default_branch" | xargs -n 1 git branch -d
}

# Git log with detailed graph formatting
gll() {
    local git_log_format='%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold white)— %an%C(reset)%C(bold yellow)%d%C(reset)'
    git log --graph --format=format:"${git_log_format}" --abbrev-commit "$@"
}

# Copy current working directory to clipboard
copycwd() {
    pwd | tr -d '\n' | pbcopy
    echo "Current path copied to clipboard."
}

# Delete all .DS_Store files recursively
dsx() {
    find . -name "*.DS_Store" -type f -delete
}

# Determine size of a file or total directory size
fs() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh
    else
        local arg=-sh
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@"
    else
        du $arg .[^.]* *
    fi
}

# Kubernetes pod SSH helper
ssh_kube_ps() {
    local i=0
    while read -r name _ _ _ _; do
        if [ $i = 1 ]; then
            pod=$name
        fi
        ((i++))
    done <<< "$(kubectl get pods --namespace=$1 --field-selector=status.phase=Running)"
    kubectl exec -i -t $pod --namespace=$1 -- /bin/sh
}

# GitHub CLI account switching
gh-account-nagooen() {
    gh auth switch --user nagooen --hostname github.com
    echo "Switched to nagooen account"
    gh auth status
}

gh-account-status() {
    gh auth status
}

# Show/hide hidden files in Finder
haf() {
    defaults write com.apple.finder AppleShowAllFiles FALSE
    killall Finder
}

saf() {
    defaults write com.apple.finder AppleShowAllFiles TRUE
    killall Finder
}

# Display command history with timestamps
hist() {
    local count=${1:-20}
    fc -li -"${count}"
}

# Ping Cloudflare DNS
pi() {
    ping -Anc 5 1.1.1.1
}

# List available Ruby versions via asdf
rlv() {
    asdf list all ruby | rg '^\d'
}

# PostgreSQL helpers
startpost() { brew services start postgresql; }
stoppost() { brew services stop postgresql; }
statpost() { ps aux | rg postgres; }
