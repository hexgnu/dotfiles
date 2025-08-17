# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for various Unix/Linux development tools and environments. The repository is structured as a collection of configuration directories that can be symlinked or copied to the user's home directory.

## Repository Structure

- `bash/` - Bash shell configuration (bashrc, profile, prompt)
- `bin/` - User scripts and executables
- `conky/` - Conky system monitor configuration
- `git/` - Git configuration and templates
- `gnupg/` - GPG configuration
- `i3/` - i3 window manager configuration (solarized theme)
- `i3blocks/` - i3blocks status bar configuration
- `nvim/` - Neovim configuration
- `tmux/` - Tmux terminal multiplexer configuration

## Key Configuration Files

### Shell Environment
- `bash/bashrc` - Main bash configuration with custom aliases, prompt, and environment setup
- `bash/profile` - Shell profile settings
- Key environment managers configured: conda, rbenv, nvm, pyenv

### Development Tools
- `git/gitconfig` - Git configuration with extensive aliases and GPG signing
- `nvim/init.lua` - Modern Neovim configuration with LSP support and Packer plugin management
- `tmux/tmux.conf` - Tmux configuration with C-z as prefix

## Common Commands

### Backup
```bash
./backup.sh  # Creates timestamped backup to /run/media/$USER/Backup/
```

### Environment Setup
The bashrc configures multiple development environments:
- Ruby: via rbenv
- Node.js: via nvm
- Python: via pyenv and conda
- Go: via PATH configuration
- Rust: via cargo

### Custom Aliases
- `pbcopy` / `pbpaste` - Clipboard operations via xclip
- `gb` - Get current git branch
- `docker` - Aliased to podman
- `vim` - Aliased to nvim if available

## Architecture Notes

### Window Manager
- Uses i3 window manager with conky for status bar
- Solarized color theme throughout
- Custom i3bar configuration with conky integration

### Shell Configuration
- Custom prompt function `hexgnu_prompt` with color coding
- Direnv integration for project-specific environments
- GPG agent configured for SSH authentication

### Development Environment Integration
The setup integrates multiple version managers and development tools:
- AWS CLI with profile support (AWS_PROFILE=augment-developer)
- Azure Functions CLI
- Multiple language version managers (rbenv, nvm, pyenv)
- Container tools (podman aliased as docker)

## Neovim Configuration

The Neovim setup uses modern Lua configuration with:
- **Plugin Manager**: Packer.nvim for plugin management
- **LSP Support**: Configured with pyright for Python development (auto-detects .venv in git repos)
- **Language Servers**: Pyright (Python), Cypher LS (Neo4j queries)
- **Autocompletion**: nvim-cmp with LSP source
- **Treesitter**: Syntax highlighting for Lua, Markdown
- **Other Plugins**: vim-fugitive (Git), ctrlp.vim (fuzzy finder), lspsaga, mason (LSP installer)

### Neovim Commands
- `gd` - Go to definition
- `gD` - Go to declaration  
- `gi` - Go to implementation
- `gl` - Show diagnostics in floating window
- `<C-Space>` - Trigger completion
- LSP servers are auto-installed via Mason

## Working with this Repository

When modifying configuration files:
1. Test changes locally before committing
2. Be aware that many configs reference absolute paths to `/home/hexgnu/`
3. The backup script excludes common cache directories and build artifacts
4. Git commits are GPG-signed by default
5. Neovim config should be symlinked from `~/.config/nvim/` to this repo's `nvim/` directory