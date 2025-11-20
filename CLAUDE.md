# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

InitDev is an automated development environment setup tool for macOS and Linux. It provides a single unified script (`main.sh`) with an interactive menu system to manage all aspects of development environment configuration. Users can selectively install tools, configure git, set up aliases, and more—all from one place.

## Repository Structure

```
InitDev/
├── main.sh                    # Entry point - orchestrates all modules
├── lib/                       # Modular components
│   ├── logging.sh            # Centralized logging (file + console with colors)
│   ├── system.sh             # OS and shell detection, Homebrew setup
│   ├── install.sh            # Package and tool installation (dependencies, Node, Bun)
│   ├── config.sh             # Configuration (git, aliases, directories, zoxide)
│   └── menu.sh               # Interactive menu system
├── components/               # Legacy component scripts (not used, can be removed)
├── README.md                 # User documentation
└── CLAUDE.md                 # This file
```

## Quick Start for Development

```bash
./main.sh              # Interactive menu (default)
./main.sh -m           # Show menu explicitly
./main.sh --check      # Check system requirements
./main.sh --install-all # Automated complete setup
./main.sh --help       # Show all options
```

The script supports multiple execution modes: interactive menu, automated setup, requirement checking, and selective component installation.

## Key Architecture

### Module Organization

The script is split into 6 specialized modules in the `lib/` directory, sourced by main.sh:

**1. lib/logging.sh** - Centralized Logging
- `log()` - Single function for all logging (file + colored console)
- **Terminal output**: Clean emoji prefixes (▶ ✓ ! ✗) - no brackets
- **Log file output**: Full format with [timestamp] [LEVEL] prefix
- Four levels with colors: INFO (blue ▶), SUCCESS (green ✓), WARN (yellow !), ERROR (red ✗)
- `init_log()` - Initialize new log file with timestamp
- `log_separator()` - Print completion summary
- All operations logged to `~/.initdev_log` with full details

**2. lib/system.sh** - System Detection
- `detect_os()` - Checks for Darwin (macOS) or Linux
- `detect_shell()` - Detects zsh or bash, sets `SHELL_RC` variable
- `check_homebrew()` - Ensures Homebrew installed (installs if missing)
- `validate_system()` - Check for required tools (curl, git)
- Universal approach: All package management via Homebrew

**3. lib/install.sh** - Installation Functions
- `install_dependencies()` - Installs 9 core tools via brew
- `install_node_tools()` - fnm + Node.js LTS + pnpm
- `install_bun()` - Bun JavaScript runtime
- Uses `brew list` to check before installing (idempotent)

**4. lib/config.sh** - Configuration Functions
- `setup_git_config()` - Git credentials, global gitignore, settings
- `setup_aliases()` - Adds 30+ aliases to shell RC file
- `setup_directories()` - Creates ~/Dev directory structure
- `setup_zoxide()` - Smart directory navigation initialization

**5. lib/menu.sh** - Interactive Menu
- `show_main_menu()` - Bash `select` statement with 10 options
- `run_complete_setup()` - Calls all setup functions in sequence
- Menu loops allowing multiple selections in one session

**6. lib/args.sh** - Argument Parsing
- `parse_args()` - Parses command-line parameters
- `show_help()` - Displays comprehensive help message
- `show_version()` - Shows version information
- `check_requirements()` - Validates system requirements
- `execute_components()` - Runs selected components from flags
- Component flags: --deps, --node, --bun, --git, --aliases, --dirs, --zoxide
- Global flags: --install-all, --skip-check, --check, --version, --help

**main.sh** - Entry Point (105 lines)
- Sources all modules from `lib/` directory
- Parses command-line arguments first
- Routes to appropriate execution mode (menu, check, install-all, or selective)
- Orchestrates system detection and validation
- Very clean flow with proper separation of concerns

### Key Design Decisions

1. **Homebrew as Universal Package Manager**
   - Replaces multi-package-manager support (dnf/apt/pacman)
   - Works on both macOS and Linux
   - Simplifies code significantly
   - Single `brew install package` works everywhere

2. **Shell Detection Instead of Fixed zsh**
   - Detects current shell from `$SHELL` environment variable
   - Defaults to zsh if detection fails
   - Sets `SHELL_RC` variable to correct rc file path
   - All shell config modifications use this variable

3. **Logging to File + Console**
   - All operations logged to `~/.initdev_log`
   - Logs written with timestamp and severity level
   - Console output uses colors for visibility
   - User can view log from menu option

4. **Idempotent Operations**
   - `brew list` checks before installing (already installed packages skipped)
   - `grep -q` checks before adding aliases/env vars
   - Directory creation checks existence first
   - Git config reconfiguration asks user first

5. **Backup System**
   - Shell RC files backed up before alias additions
   - Backup filename includes timestamp
   - Backups stored in home directory with `.bak` extension

### Alias System (lib/config.sh)

Aliases defined in `setup_aliases()` function:
- Defined as bash array with comment headers
- Grouped by category (General, Package Manager, Navigation, Git, System)
- Comments preserved in shell RC file
- Duplicates prevented by grep check before adding
- Counter tracks successful additions

**Major Aliases:**
- Navigation: `hd`, `projs`, `study`, `cb`, `lg`
- Package managers: `pnpmd`, `pnpmb`, `bund`
- Git: `ggclone`, `ggadd`, `ggsta`, `gglog`, `ggswi`
- System: `cl`, `neo`, `reload`, `python`

### Git Configuration (lib/config.sh)

The `setup_git_config()` function:
- Checks if already configured, asks before reconfiguring
- Prompts for email with regex validation
- Creates global `.gitignore_global` with:
  - Environment variables (.env files)
  - IDE files (.vscode, .idea)
  - Node.js artifacts (node_modules, dist, build)
  - Bun/fnm directories
  - macOS patterns (.DS_Store, iCloud files)
- Sets important git config:
  - `init.defaultBranch main`
  - `core.editor nvim`
  - `merge.ff only` (fast-forward only)
  - `core.excludesfile ~/.gitignore_global`

## Command-Line Parameters

### Usage Modes

**Interactive Menu (Default)**
```bash
./main.sh         # Shows 10-option menu
./main.sh -m      # Explicitly show menu
```

**Check System Requirements**
```bash
./main.sh --check # Validate all requirements
```

**Automated Complete Setup**
```bash
./main.sh --install-all # Installs everything non-interactively
```

**Selective Component Installation**
```bash
./main.sh --deps --node           # Install only dependencies and Node.js
./main.sh --git --aliases         # Configure git and setup aliases
./main.sh --deps --git --zoxide   # Multiple components in order
```

**Component Flags**
- `--deps` - Install core dependencies
- `--node` - Install Node.js tools (fnm + LTS + pnpm)
- `--bun` - Install Bun runtime
- `--git` - Configure git
- `--aliases` - Setup shell aliases
- `--dirs` - Create directory structure
- `--zoxide` - Setup zoxide navigation

**Global Flags**
- `--install-all` - Run complete setup non-interactively
- `--skip-check` - Skip system validation (use with caution)
- `-h, --help` - Show help message
- `-v, --version` - Show version information
- `-c, --check` - Check requirements only

### Implementation Details

**Argument Parsing Flow** (lib/args.sh)
1. `parse_args()` processes all arguments into global flags
2. Default to `SHOW_MENU=true` if no flags specified
3. Component flags can be combined for multi-component installation

**Execution Routing** (main.sh)
1. Parse arguments first (before system detection)
2. Handle help/version immediately (no system detection needed)
3. System detection (OS, shell, validation)
4. Route based on flags:
   - `--help` or `-h`: Show help and exit
   - `--version` or `-v`: Show version and exit
   - `--check`: Run `check_requirements()` and exit
   - `--install-all`: Run all setup functions in sequence
   - Component flags: Run only selected components
   - No flags: Show interactive menu (default)

**Idempotent with Parameters**
- Check if packages installed before installing
- Ask before reconfiguring git if already set
- Skip components that are already done

## Development Notes

### Code Organization
- **Modularity**: Each module has single responsibility (logging, system, install, config, menu)
- **Separation of Concerns**: main.sh only sources modules and orchestrates
- **Global Variables**: Defined in relevant modules (SHELL_RC, OS_TYPE, DETECTED_SHELL)
- **Logging Throughout**: All modules use shared `log()` function

### Error Handling & Safety
- Uses `set -u` in main.sh to exit on undefined variables
- Doesn't use `set -e` - commands continue on failure (allows graceful degradation)
- Each installation function checks if package already installed before installing
- Git config function asks for confirmation if already configured

### Requirements
- Bash 4.0+ (for array syntax used in aliases)
- curl (required to download Homebrew and Bun)
- Sudo access (for Homebrew installation on Linux)
- Internet connection

### Idempotency
- Can run `./main.sh` multiple times safely
- Shell RC backups created with timestamps
- Installation functions skip already-installed packages
- Configuration checks before overwriting settings

### Testing
- All scripts checked with `bash -n` for syntax errors
- Should test on both macOS and Linux systems
- Easy to extend: add new functions to appropriate modules

## Maintenance Guidelines

- **Adding new features**: Create function in appropriate module file
- **New installations**: Add to `install.sh` following existing patterns
- **New configuration**: Add to `config.sh` following existing patterns
- **New aliases**: Add to array in `setup_aliases()` in config.sh
- **Update logging**: All modules can use `log()` function from logging.sh

## Legacy Scripts

The old component scripts in `components/` and root (`initAlias.sh`, `installApps.sh`, etc.) are now:
- Not used by the new modular main.sh
- Can be archived or removed safely
- Kept for reference if needed in future
