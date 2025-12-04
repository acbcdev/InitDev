#!/bin/bash

###############################################################################
# Arguments Module - Command-line parameter parsing
###############################################################################

# Global flags
SHOW_MENU=false
SHOW_HELP=false
CHECK_ONLY=false
SHOW_VERSION=false
INSTALL_ALL=false
SKIP_CHECK=false

# Component flags
INSTALL_DEPS=false
INSTALL_NODE=false
INSTALL_BUN_FLAG=false
SETUP_GIT=false
SETUP_GIT_USER=false
SETUP_GIT_SETTINGS=false
SETUP_ALIASES_FLAG=false
SETUP_DIRS=false
SETUP_ZOXIDE_FLAG=false

# Version
readonly VERSION="1.0.0"

###############################################################################
# Display help message
###############################################################################
show_help() {
  cat << 'EOF'
Usage: ./main.sh [OPTIONS]

InitDev - Development Environment Setup Tool for macOS and Linux

OPTIONS:
  -m, --menu              Show interactive menu (default behavior)
  -h, --help              Display this help message
  -c, --check             Check system requirements only
  -v, --version           Show version information

INSTALL OPTIONS:
   --install-all           Run complete setup non-interactively
   --deps                  Install dependencies only
   --node                  Install Node.js tools only
   --bun                   Install Bun only
   --git                   Configure Git only (complete setup)
   --git-user              Configure Git user (name/email) only
   --git-settings          Configure Git settings only (no user config)
   --aliases               Setup shell aliases only
   --dirs                  Create directories only
   --zoxide                Setup Zoxide only

MODIFIERS:
  --skip-check            Skip system validation (use with caution)

EXAMPLES:
  ./main.sh               Open interactive menu
  ./main.sh -m            Same as above
  ./main.sh --check       Check if system requirements are met
  ./main.sh --install-all Run complete setup automatically
  ./main.sh --deps --node Install dependencies and Node.js only
  ./main.sh --git --aliases Configure Git and setup aliases
  ./main.sh -h            Show this help message

EOF
}

###############################################################################
# Display version
###############################################################################
show_version() {
  cat << EOF
InitDev v${VERSION}

Development Environment Setup Tool for macOS and Linux
Powered by Homebrew | Supports: zsh, bash

GitHub: https://github.com/acbc/InitDev
EOF
}

###############################################################################
# Check system requirements
###############################################################################
check_requirements() {
  log "INFO" "=========================================="
  log "INFO" "System Requirements Check"
  log "INFO" "=========================================="

  local all_ok=true

  # Check OS
  if [[ "$OS_TYPE" == "Darwin" ]]; then
    log "SUCCESS" "OS: macOS ($(sw_vers -productVersion))"
  elif [[ "$OS_TYPE" == "Linux" ]]; then
    log "SUCCESS" "OS: Linux"
  else
    log "ERROR" "OS: Unsupported"
    all_ok=false
  fi

  # Check Bash version
  local bash_version="${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}"
  if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
    log "SUCCESS" "Bash: v${bash_version}"
  else
    log "ERROR" "Bash: v${bash_version} (requires 4.0+)"
    all_ok=false
  fi

  # Check curl
  if command -v curl &> /dev/null; then
    log "SUCCESS" "curl: Installed"
  else
    log "ERROR" "curl: Not found (required)"
    all_ok=false
  fi

  # Check git
  if command -v git &> /dev/null; then
    log "SUCCESS" "git: Installed ($(git --version | awk '{print $3}'))"
  else
    log "WARN" "git: Not found (will be installed)"
  fi

  # Check Homebrew
  if command -v brew &> /dev/null; then
    local brew_version=$(brew --version | head -n1)
    log "SUCCESS" "Homebrew: $brew_version"
  else
    log "WARN" "Homebrew: Not found (will be installed)"
  fi

  # Check shell
  if [[ "$DETECTED_SHELL" == "zsh" ]]; then
    log "SUCCESS" "Shell: zsh ($SHELL_RC)"
  elif [[ "$DETECTED_SHELL" == "bash" ]]; then
    log "SUCCESS" "Shell: bash ($SHELL_RC)"
  else
    log "WARN" "Shell: Unknown"
  fi

  log "INFO" "=========================================="

  if [[ "$all_ok" == true ]]; then
    log "SUCCESS" "All required components found!"
    return 0
  else
    log "WARN" "Some components are missing but will be installed"
    return 0
  fi
}

###############################################################################
# Execute selected components
###############################################################################
execute_components() {
  local executed=false

  if [[ "$INSTALL_DEPS" == true ]]; then
    install_dependencies
    executed=true
  fi

  if [[ "$INSTALL_NODE" == true ]]; then
    install_node_tools
    executed=true
  fi

  if [[ "$INSTALL_BUN_FLAG" == true ]]; then
    install_bun
    executed=true
  fi

  if [[ "$SETUP_GIT" == true ]]; then
    setup_git_config
    executed=true
  fi

  if [[ "$SETUP_GIT_USER" == true ]]; then
    setup_git_user_config
    executed=true
  fi

  if [[ "$SETUP_GIT_SETTINGS" == true ]]; then
    setup_git_general_config
    executed=true
  fi

  if [[ "$SETUP_ALIASES_FLAG" == true ]]; then
    setup_aliases
    executed=true
  fi

  if [[ "$SETUP_DIRS" == true ]]; then
    setup_directories
    executed=true
  fi

  if [[ "$SETUP_ZOXIDE_FLAG" == true ]]; then
    setup_zoxide
    executed=true
  fi

  if [[ "$executed" == false ]]; then
    log "WARN" "No components selected"
    return 1
  fi

  log "SUCCESS" "Selected components installed"
  return 0
}

###############################################################################
# Parse command-line arguments
###############################################################################
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -m | --menu)
        SHOW_MENU=true
        shift
        ;;
      -h | --help)
        SHOW_HELP=true
        shift
        ;;
      -c | --check)
        CHECK_ONLY=true
        shift
        ;;
      -v | --version)
        SHOW_VERSION=true
        shift
        ;;
      --install-all)
        INSTALL_ALL=true
        INSTALL_DEPS=true
        INSTALL_NODE=true
        INSTALL_BUN_FLAG=true
        SETUP_GIT=true
        SETUP_ALIASES_FLAG=true
        SETUP_DIRS=true
        SETUP_ZOXIDE_FLAG=true
        shift
        ;;
      --skip-check)
        SKIP_CHECK=true
        shift
        ;;
      --deps)
        INSTALL_DEPS=true
        shift
        ;;
      --node)
        INSTALL_NODE=true
        shift
        ;;
      --bun)
        INSTALL_BUN_FLAG=true
        shift
        ;;
      --git)
        SETUP_GIT=true
        shift
        ;;
      --git-user)
        SETUP_GIT_USER=true
        shift
        ;;
      --git-settings)
        SETUP_GIT_SETTINGS=true
        shift
        ;;
      --aliases)
        SETUP_ALIASES_FLAG=true
        shift
        ;;
      --dirs)
        SETUP_DIRS=true
        shift
        ;;
      --zoxide)
        SETUP_ZOXIDE_FLAG=true
        shift
        ;;
      *)
        log "ERROR" "Unknown option: $1"
        show_help
        exit 1
        ;;
    esac
  done

  # Default to menu if no flags specified
  if [[ "$SHOW_HELP" == false ]] && [[ "$SHOW_VERSION" == false ]] && \
     [[ "$CHECK_ONLY" == false ]] && [[ "$INSTALL_ALL" == false ]] && \
     [[ "$INSTALL_DEPS" == false ]] && [[ "$INSTALL_NODE" == false ]] && \
     [[ "$INSTALL_BUN_FLAG" == false ]] && [[ "$SETUP_GIT" == false ]] && \
     [[ "$SETUP_GIT_USER" == false ]] && [[ "$SETUP_GIT_SETTINGS" == false ]] && \
     [[ "$SETUP_ALIASES_FLAG" == false ]] && [[ "$SETUP_DIRS" == false ]] && \
     [[ "$SETUP_ZOXIDE_FLAG" == false ]]; then
    SHOW_MENU=true
  fi
}
