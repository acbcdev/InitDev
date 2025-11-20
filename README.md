# InitDev

Automated development environment setup for macOS and Linux using Homebrew.

## Quick Start

```bash
./main.sh
```

This will launch an interactive menu where you can choose what to set up.

## Features

- **OS Auto-Detection**: Works on macOS and Linux
- **Shell Detection**: Automatically detects and configures zsh or bash
- **Homebrew Integration**: Uses Homebrew as universal package manager
- **Interactive Menu**: Choose which components to install
- **Detailed Logging**: All actions logged to `~/.initdev_log`
- **Backup System**: Automatic backups of shell config before modifications
- **Color Output**: Clear visual feedback with colors

## What Gets Installed

- **Dependencies**: curl, git, ranger, zoxide, exa, fastfetch, lazygit, gh, nvim
- **Node.js**: fnm (Fast Node Manager) + Node.js LTS + pnpm
- **Bun**: JavaScript runtime (optional)
- **Git Config**: User setup + global gitignore + useful settings
- **Shell Aliases**: 30+ useful aliases for development
- **Development Directories**: ~/Dev structure with projects, platzi, cmt folders
- **Zoxide**: Smart directory navigation

## Menu Options

1. **Install Dependencies** - Core development tools
2. **Install Node.js Tools** - fnm, Node.js LTS, pnpm
3. **Install Bun** - Bun JavaScript runtime
4. **Configure Git** - User credentials and global settings
5. **Setup Aliases** - Shell aliases for common commands
6. **Create Directories** - Development directory structure
7. **Setup Zoxide** - Smart cd replacement
8. **Run Complete Setup** - Everything at once
9. **View Log** - See detailed installation log
10. **Exit**

## Available Aliases

### Navigation
- `hd` → `cd ~/Dev/`
- `projs` → `cd ~/Dev/projects/`
- `study` → `cd ~/Dev/platzi/`
- `cb` → `cd ..`
- `lg` → `lazygit`

### Package Managers
- `pnpmd` → `pnpm run dev`
- `pnpmb` → `pnpm run build`
- `bund` → `bun dev`

### Git
- `ggclone` → `git clone`
- `ggadd` → `git add .`
- `ggsta` → `git status`

### System
- `cl` → `clear`
- `neo` → `fastfetch`
- `reload` → Reload shell config

## Requirements

- Bash 4.0+
- curl (will be installed)
- Internet connection
- Sudo access (for some system packages)

## Logging

All operations are logged to `~/.initdev_log`. View the log from the menu or directly:

```bash
cat ~/.initdev_log
```

## Troubleshooting

If something fails:
1. Check the log file: `~/.initdev_log`
2. Shell configs are backed up automatically with timestamps
3. You can re-run `./main.sh` and select just the failed component

## After Installation

Apply the changes to your current shell:

```bash
source ~/.zshrc  # for zsh
# or
source ~/.bashrc # for bash
```

## Components

The `components/` directory contains individual setup scripts that are called by main.sh but can also be run independently if needed.