#!/usr/bin/env bash
# Dotfiles installation script
# Creates symlinks from this repo to your home directory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Dotfiles Installation Script      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Function to create a symlink
create_symlink() {
    local source="$1"
    local target="$2"
    local backup_dir="$HOME/.dotfiles_backup"

    # Create backup directory if needed
    if [[ ! -d "$backup_dir" ]]; then
        mkdir -p "$backup_dir"
    fi

    # If target exists and is not a symlink, back it up
    if [[ -e "$target" && ! -L "$target" ]]; then
        echo -e "${YELLOW}  Backing up existing file: $target${NC}"
        mv "$target" "$backup_dir/$(basename "$target").$(date +%Y%m%d_%H%M%S)"
    fi

    # Remove existing symlink if it exists
    if [[ -L "$target" ]]; then
        rm "$target"
    fi

    # Create parent directory if needed
    local target_dir=$(dirname "$target")
    if [[ ! -d "$target_dir" ]]; then
        mkdir -p "$target_dir"
    fi

    # Create symlink
    ln -s "$source" "$target"
    echo -e "${GREEN}  ✓ Linked: $target → $source${NC}"
}

# Function to install shell configurations
install_shell() {
    echo -e "${BLUE}Installing shell configurations...${NC}"
    create_symlink "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"
    create_symlink "$DOTFILES_DIR/shell/.bashrc" "$HOME/.bashrc"
    create_symlink "$DOTFILES_DIR/shell/.aliases" "$HOME/.aliases"
    create_symlink "$DOTFILES_DIR/shell/.functions" "$HOME/.functions"
    echo ""
}

# Function to install Git configurations
install_git() {
    echo -e "${BLUE}Installing Git configurations...${NC}"
    create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
    create_symlink "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

    echo -e "${YELLOW}  ⚠ Don't forget to update your name and email in ~/.gitconfig${NC}"
    echo ""
}

# Function to install Vim configurations
install_vim() {
    echo -e "${BLUE}Installing Vim configurations...${NC}"
    create_symlink "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
    create_symlink "$DOTFILES_DIR/vim/.editorconfig" "$HOME/.editorconfig"
    echo ""
}

# Function to install Homebrew packages
install_homebrew() {
    echo -e "${BLUE}Installing Homebrew packages...${NC}"

    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo -e "${YELLOW}  Homebrew not found. Installing...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        echo -e "${GREEN}  ✓ Homebrew is already installed${NC}"
    fi

    # Install packages from Brewfile
    if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
        echo -e "${BLUE}  Installing packages from Brewfile...${NC}"
        brew bundle --file="$DOTFILES_DIR/Brewfile"
    fi
    echo ""
}

# Function to apply macOS defaults
install_macos_defaults() {
    echo -e "${BLUE}Applying macOS defaults...${NC}"

    if [[ -f "$DOTFILES_DIR/macos/defaults.sh" ]]; then
        bash "$DOTFILES_DIR/macos/defaults.sh"
    else
        echo -e "${RED}  ✗ macOS defaults script not found${NC}"
    fi
    echo ""
}

# Function to install Claude Code configurations
install_claude() {
    echo -e "${BLUE}Installing Claude Code configurations...${NC}"

    if [[ -d "$DOTFILES_DIR/claude" ]]; then
        # Create ~/.claude directory if it doesn't exist
        if [[ ! -d "$HOME/.claude" ]]; then
            mkdir -p "$HOME/.claude"
        fi

        # Copy the entire claude directory structure
        cp -r "$DOTFILES_DIR/claude/"* "$HOME/.claude/"

        echo -e "${GREEN}  ✓ Claude Code configurations installed to ~/.claude${NC}"
        echo -e "${YELLOW}  ℹ This includes:${NC}"
        echo -e "${YELLOW}    - Agents (specialized AI workflows)${NC}"
        echo -e "${YELLOW}    - Skills (reusable workflow patterns)${NC}"
        echo -e "${YELLOW}    - Commands (custom CLI commands)${NC}"
        echo -e "${YELLOW}    - Notes and plans${NC}"
    else
        echo -e "${RED}  ✗ Claude configuration directory not found${NC}"
    fi
    echo ""
}

# Main installation menu
show_menu() {
    echo "What would you like to install?"
    echo ""
    echo "  1) All (shell, git, vim, claude, homebrew, macOS defaults)"
    echo "  2) Shell configurations only"
    echo "  3) Git configurations only"
    echo "  4) Vim configurations only"
    echo "  5) Claude Code configurations only"
    echo "  6) Homebrew packages only"
    echo "  7) macOS defaults only"
    echo "  0) Exit"
    echo ""
    read -p "Enter your choice [0-7]: " choice

    case $choice in
        1)
            install_shell
            install_git
            install_vim
            install_claude
            install_homebrew
            install_macos_defaults
            ;;
        2)
            install_shell
            ;;
        3)
            install_git
            ;;
        4)
            install_vim
            ;;
        5)
            install_claude
            ;;
        6)
            install_homebrew
            ;;
        7)
            install_macos_defaults
            ;;
        0)
            echo -e "${BLUE}Exiting...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Please try again.${NC}"
            echo ""
            show_menu
            ;;
    esac
}

# Run the menu
show_menu

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║      Installation Complete! 🎉         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Restart your terminal or run: ${BLUE}source ~/.zshrc${NC}"
echo -e "  2. Update Git config: ${BLUE}vim ~/.gitconfig${NC}"
echo -e "  3. Review installed packages: ${BLUE}brew list${NC}"
echo ""
echo -e "${YELLOW}Backups:${NC}"
echo -e "  Original files backed up to: ${BLUE}~/.dotfiles_backup${NC}"
echo ""
