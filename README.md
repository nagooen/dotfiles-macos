# dotfiles-macos

Automated macOS development environment setup using symlinks.

## Features

- **Shell Configuration**: Zsh and Bash with aliases and custom functions
- **Git Setup**: Global Git configuration and ignore patterns
- **Vim Configuration**: Sensible Vim defaults and EditorConfig
- **Claude Code Configuration**: AI-powered development workflow with specialized agents and skills
- **Homebrew Packages**: Automated installation of development tools
- **macOS Defaults**: Optimized system preferences for developers

## Quick Start

```bash
# Clone the repository
git clone <your-repo-url> ~/projects/dotfiles-macos
cd ~/projects/dotfiles-macos

# Make install script executable
chmod +x install.sh

# Run installation
./install.sh
```

## Installation Options

The install script provides an interactive menu:

1. **All** - Install everything (recommended for new machines)
2. **Shell configurations only** - Just shell configs (.zshrc, .bashrc, aliases, functions)
3. **Git configurations only** - Just Git config (.gitconfig, .gitignore_global)
4. **Vim configurations only** - Just Vim config (.vimrc, .editorconfig)
5. **Claude Code configurations only** - AI workflow configurations (agents, skills, commands)
6. **Homebrew packages only** - Install packages from Brewfile
7. **macOS defaults only** - Apply system preferences

## Directory Structure

```
dotfiles-macos/
├── shell/              # Shell configurations
│   ├── .zshrc
│   ├── .bashrc
│   ├── .aliases
│   └── .functions
├── git/                # Git configurations
│   ├── .gitconfig
│   └── .gitignore_global
├── vim/                # Vim configurations
│   ├── .vimrc
│   └── .editorconfig
├── claude/             # Claude Code AI configurations
│   ├── agents/         # Specialized AI agents
│   ├── skills/         # Reusable workflow patterns
│   ├── commands/       # Custom CLI commands
│   ├── notes/          # Project notes and context
│   └── plans/          # Planning documents
├── macos/              # macOS system preferences
│   └── defaults.sh
├── scripts/            # Additional utility scripts
├── Brewfile            # Homebrew package definitions
├── install.sh          # Installation script
└── README.md           # This file
```

## What Gets Installed

### Shell Tools
- Zsh with completions and enhancements
- Useful aliases for git, navigation, and system commands
- Custom functions for common tasks

### Development Tools
- Node.js, Python, Go
- Version managers (nvm, asdf)
- Git and GitHub CLI
- Modern CLI tools (ripgrep, fzf, bat, exa)

### GUI Applications
- Visual Studio Code
- iTerm2
- Google Chrome
- Programming fonts (Fira Code, JetBrains Mono)

### macOS Tweaks
- Fast keyboard repeat rate
- Show hidden files in Finder
- Enable tap to click
- Disable auto-correct
- And many more developer-friendly settings

### Claude Code Configuration
- **Specialized Agents**: AI agents for different development workflows
  - `@codebase-explorer` - Deep code exploration and pattern discovery
  - `@business-analyst` - Feature decomposition and planning
  - `@full-stack-engineer` - Full-stack implementation with TDD
  - `@qa-enforcer` - Quality verification before commits
  - And more project-specific agents
- **Skills**: Reusable workflow patterns
  - `bug-fix` - Systematic bug fixing with Jira integration
  - `tdd` - Test-driven development cycle
  - `vertical-slice` - Feature slicing patterns
  - `retro` - Retrospective workflow
  - And more...
- **Commands**: Custom CLI commands for planning and development workflows
- **Best Practices**: TDD, clean code, SOLID principles integration

## Customization

### Shell
Edit `shell/.aliases` and `shell/.functions` to add your own shortcuts.

### Git
Update your name and email in `git/.gitconfig`:
```bash
[user]
    name = Your Name
    email = your.email@example.com
```

### Homebrew
Add or remove packages in `Brewfile`. Then run:
```bash
brew bundle --file=~/projects/dotfiles-macos/Brewfile
```

### macOS Defaults
Edit `macos/defaults.sh` to customize system preferences. Apply changes:
```bash
bash ~/projects/dotfiles-macos/macos/defaults.sh
```

## Backups

Original files are automatically backed up to `~/.dotfiles_backup` with timestamps before being replaced.

## Updating

To update your dotfiles:

```bash
cd ~/projects/dotfiles-macos
git pull origin main

# Re-run installation to update symlinks
./install.sh
```

## Uninstalling

To remove symlinks and restore backups:

```bash
# Remove symlinks
rm ~/.zshrc ~/.bashrc ~/.aliases ~/.functions
rm ~/.gitconfig ~/.gitignore_global
rm ~/.vimrc ~/.editorconfig

# Restore from backup (adjust timestamp as needed)
cp ~/.dotfiles_backup/* ~/
```

## New Machine Setup

1. Install Xcode Command Line Tools:
   ```bash
   xcode-select --install
   ```

2. Clone this repository:
   ```bash
   git clone <your-repo-url> ~/projects/dotfiles-macos
   ```

3. Run the installation:
   ```bash
   cd ~/projects/dotfiles-macos
   chmod +x install.sh
   ./install.sh
   ```

4. Restart your terminal

## Tips

- Source your shell config after making changes: `source ~/.zshrc`
- Keep your Brewfile updated: `brew bundle dump --file=~/projects/dotfiles-macos/Brewfile --force`
- Review macOS defaults before applying them
- Commit your customizations to version control

## Requirements

- macOS (tested on Ventura and later)
- Bash or Zsh
- Internet connection for Homebrew installation

## Contributing

Feel free to customize this setup for your own needs!

## License

MIT

## Acknowledgments

Inspired by dotfiles repositories from the community.
