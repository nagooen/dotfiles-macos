# dotfiles-macos

Automated macOS development environment setup using [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```bash
# Clone the repository
git clone <your-repo-url> ~/projects/dotfiles-macos
cd ~/projects/dotfiles-macos

# Preview what will be linked
./setup.sh --dry-run

# Run setup
./setup.sh
```

## How It Works

Each top-level directory is a **stow package**. The contents mirror your home directory structure. Running `stow <package>` creates symlinks from `$HOME` to the files in that package.

For example, `git/.gitconfig` becomes `~/.gitconfig`.

## Packages

| Package | Contents | Description |
|---------|----------|-------------|
| `asdf` | `.tool-versions`, `.asdfrc` | Language version management |
| `bash` | `.bashrc` | Bash shell configuration |
| `brew` | `Brewfile` | Homebrew package definitions |
| `ghostty` | `.config/ghostty/config` | Ghostty terminal emulator |
| `git` | `.gitconfig`, `.gitignore_global`, `.gitmessage`, `.gitconfig.d/` | Git configuration with GPG signing and conditional includes |
| `node` | `.npmrc`, `.default-npm-packages` | Node.js/npm configuration |
| `rc` | `.ripgreprc`, `.hushlogin` | CLI tool configs |
| `ruby` | `.gemrc`, `.irbrc`, `.pryrc`, `.default-gems`, `.rubocop.yml` | Ruby development environment |
| `starship` | `.config/starship.toml` | Cross-shell prompt with git status |
| `tmux` | `.config/tmux/tmux.conf`, themes | Terminal multiplexer with TokyoNight |
| `vim` | `.vimrc`, `.editorconfig` | Vim editor configuration |
| `zsh` | `.zshrc`, `.config/zsh/*.zsh` | Zsh with Oh My Zsh, aliases, functions, docker utils |

### Non-Stow Directories

These directories are **not** stowed (they have `.stow-local-ignore` files):

| Directory | Purpose |
|-----------|---------|
| `claude/` | Claude Code AI workflow configs (special install via `install.sh`) |
| `macos/` | macOS system preferences (`defaults.sh` - run manually) |
| `scripts/` | Utility scripts |

## Customization

### Machine-specific overrides

These files are sourced if they exist but are **not** tracked in git:

- `~/.secrets` - API tokens, PATs (create manually, **never commit**)
- `~/.zshrc.local` - Machine-specific Zsh config
- `~/.bashrc.local` - Machine-specific Bash config
- `~/.gitconfig.local` - Machine-specific Git config

### Conditional Git config

Git identity switches automatically based on repo location:

- `~/projects/personal/` - Uses personal email
- `~/projects/mableit/` - Uses work email

Edit `git/.gitconfig.d/personal` and `git/.gitconfig.d/work` to change.

## Managing Individual Packages

```bash
# Stow a single package
cd ~/projects/dotfiles-macos
stow git

# Unstow (remove symlinks)
stow -D git

# Re-stow (unstow then stow, useful after changes)
stow -R git

# Preview without applying
stow -n -v git
```

## After Setup

1. Restart terminal or `source ~/.zshrc`
2. Create `~/.secrets` for API tokens
3. Install Homebrew packages: `brew bundle --file=~/projects/dotfiles-macos/brew/Brewfile`
4. Apply macOS defaults: `bash ~/projects/dotfiles-macos/macos/defaults.sh`
5. Install Tmux plugins: open tmux, press `<prefix> + I`

## Requirements

- macOS (Apple Silicon or Intel)
- GNU Stow (`brew install stow`)
- Git

## License

MIT
