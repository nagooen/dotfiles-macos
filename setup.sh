#!/usr/bin/env bash

set -e

################################################################################
# setup.sh
#
# This script uses GNU Stow to symlink dotfiles into place.
# It can be run safely multiple times on the same machine (idempotent).
#
# Usage: ./setup.sh [OPTIONS]
#
# Options:
#   --dry-run    Show what would be done without making any changes
#   --help       Show this help message
################################################################################

DRY_RUN=false

# Stow packages to install (order doesn't matter for stow)
STOW_PACKAGES=(
    asdf
    bash
    brew
    ghostty
    git
    node
    rc
    ruby
    starship
    tmux
    vim
    zsh
)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

show_help() {
    cat <<EOF
Usage: $0 [OPTIONS]

Sets up dotfiles using GNU Stow for symlink management.
Can be run safely multiple times on the same machine.

Options:
  --dry-run    Show what would be done without making any changes
  --help       Show this help message

Stow packages: ${STOW_PACKAGES[*]}

Examples:
  $0                # Normal setup
  $0 --dry-run      # Preview changes without applying them
EOF
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

info() { printf "${BLUE}[INFO]${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}[WARN]${NC} %s\n" "$1" >&2; }
error() { printf "${RED}[ERROR]${NC} %s\n" "$1" >&2; }
success() { printf "${GREEN}[OK]${NC} %s\n" "$1"; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

check_prerequisites() {
    local osname
    osname=$(uname)

    if [ "${osname}" != "Darwin" ]; then
        error "This script only supports macOS. Current OS: ${osname}"
        exit 1
    fi

    if ! command -v stow >/dev/null; then
        error "GNU Stow is required but was not found."
        info "Install it with: brew install stow"
        exit 1
    fi

    success "Prerequisites check passed (macOS + stow)"
}

setup_directories() {
    if [ ! -d "${HOME}/.config" ]; then
        if [[ "${DRY_RUN}" == "true" ]]; then
            info "[DRY RUN] Would create: ${HOME}/.config"
        else
            mkdir -p "${HOME}/.config"
            info "Created ${HOME}/.config"
        fi
    fi

    if [ ! -d "${HOME}/.local/bin" ]; then
        if [[ "${DRY_RUN}" == "true" ]]; then
            info "[DRY RUN] Would create: ${HOME}/.local/bin"
        else
            mkdir -p "${HOME}/.local/bin"
            info "Created ${HOME}/.local/bin"
        fi
    fi
}

backup_conflict() {
    local file="$1"
    local backup_suffix
    backup_suffix="$(date +%Y%m%d_%H%M%S)"
    local backup_path="${file}.backup_${backup_suffix}"

    if [[ "${DRY_RUN}" == "true" ]]; then
        info "[DRY RUN] Would backup: ${file} -> ${backup_path}"
    else
        warn "Backing up: ${file} -> ${backup_path}"
        mv "${file}" "${backup_path}"
    fi
}

handle_conflicts() {
    info "Checking for stow conflicts..."

    local conflicts_found=0

    # Known files that stow will try to create symlinks for.
    # If real files (not symlinks) exist at these paths, back them up.
    local potential_conflicts=(
        ".asdfrc"
        ".bashrc"
        ".config/ghostty"
        ".config/starship.toml"
        ".config/tmux"
        ".config/zsh"
        ".default-gems"
        ".default-npm-packages"
        ".editorconfig"
        ".gemrc"
        ".gitconfig"
        ".gitconfig.d/personal"
        ".gitconfig.d/work"
        ".gitignore_global"
        ".gitmessage"
        ".hushlogin"
        ".irbrc"
        ".npmrc"
        ".pryrc"
        ".ripgreprc"
        ".rubocop.yml"
        ".tool-versions"
        ".vimrc"
        ".zshrc"
        "Brewfile"
    )

    for item in "${potential_conflicts[@]}"; do
        local target="${HOME}/${item}"
        if [[ -e "${target}" && ! -L "${target}" ]]; then
            conflicts_found=$((conflicts_found + 1))
            backup_conflict "${target}"
        fi
    done

    if [[ ${conflicts_found} -gt 0 ]]; then
        info "Backed up ${conflicts_found} conflicting files"
    else
        success "No conflicts detected"
    fi
}

setup_symlinks() {
    echo ""
    info "Setting up symlinks with GNU Stow..."
    echo ""

    local stowed=0
    local failed=0

    for package in "${STOW_PACKAGES[@]}"; do
        local package_dir="${DOTFILES_DIR}/${package}"
        if [[ ! -d "${package_dir}" ]]; then
            warn "Skipping missing package: ${package}"
            continue
        fi

        if [[ "${DRY_RUN}" == "true" ]]; then
            info "[DRY RUN] Would stow: ${package}"
            # Show what would be linked
            (cd "${DOTFILES_DIR}" && stow -n -v "${package}" 2>&1 | grep -v "WARNING" || true)
        else
            if (cd "${DOTFILES_DIR}" && stow "${package}" 2>&1); then
                success "Stowed: ${package}"
                stowed=$((stowed + 1))
            else
                error "Failed to stow: ${package}"
                failed=$((failed + 1))
            fi
        fi
    done

    echo ""
    if [[ "${DRY_RUN}" == "false" ]]; then
        info "Stowed ${stowed} packages (${failed} failed)"
    fi
}

setup_tmux() {
    if command -v tmux &>/dev/null; then
        local tpm_dir="${HOME}/.config/tmux/plugins/tpm"
        if [ ! -d "${tpm_dir}" ]; then
            info "Installing Tmux Plugin Manager..."
            if [[ "${DRY_RUN}" == "true" ]]; then
                info "[DRY RUN] Would clone TPM to: ${tpm_dir}"
            else
                git clone https://github.com/tmux-plugins/tpm "${tpm_dir}"
                success "TPM installed"
            fi
        else
            info "TPM already installed"
        fi
    fi
}

show_next_steps() {
    echo ""
    echo -e "${GREEN}Setup complete!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Create ~/.secrets for API tokens (never commit this file)"
    echo "  3. Create ~/.gitconfig.local for machine-specific git overrides"
    echo "  4. Install Homebrew packages: brew bundle --file=~/projects/dotfiles-macos/brew/Brewfile"
    echo "  5. Apply macOS defaults: bash ~/projects/dotfiles-macos/macos/defaults.sh"
    if command -v tmux &>/dev/null; then
        echo "  6. Install Tmux plugins: open tmux and press <prefix> + I"
    fi
    echo ""
}

# Error handling
trap 'error "Script failed at line $LINENO"' ERR

# Main
main() {
    echo -e "${BLUE}Dotfiles Setup${NC}"
    echo "=============="
    echo ""

    if [[ "${DRY_RUN}" == "true" ]]; then
        warn "DRY RUN MODE - No changes will be made"
        echo ""
    fi

    check_prerequisites
    setup_directories
    handle_conflicts
    setup_symlinks
    setup_tmux
    show_next_steps
}

main "$@"
