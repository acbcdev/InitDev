#!/bin/bash

###############################################################################
# InitDev - Unified Development Environment Setup Script
# Works on macOS and Linux using Homebrew as universal package manager
# Author: ACBC
#
# This is the main entry point that orchestrates all modules
# Usage: ./main.sh [OPTIONS]
###############################################################################

set -u  # Exit on undefined variables

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source all modules
source "$SCRIPT_DIR/lib/logging.sh"
source "$SCRIPT_DIR/lib/system.sh"
source "$SCRIPT_DIR/lib/install.sh"
source "$SCRIPT_DIR/lib/config.sh"
source "$SCRIPT_DIR/lib/menu.sh"
source "$SCRIPT_DIR/lib/args.sh"

###############################################################################
# Main Execution
###############################################################################

main() {
  # Initialize log file
  init_log

  # Parse command-line arguments
  parse_args "$@"

  # Handle special flags first (no system detection needed)
  if [[ "$SHOW_HELP" == true ]]; then
    show_help
    return 0
  fi

  if [[ "$SHOW_VERSION" == true ]]; then
    show_version
    return 0
  fi

  # System detection (required for all other operations)
  detect_os
  detect_shell

  if [[ "$SKIP_CHECK" == false ]]; then
    validate_system
  fi

  # Check Homebrew for installation operations
  if [[ "$CHECK_ONLY" == false ]] && [[ "$SHOW_MENU" == false ]]; then
    check_homebrew
  fi

  log "SUCCESS" "System detection completed"
  echo ""

  # Handle different execution modes
  if [[ "$CHECK_ONLY" == true ]]; then
    # Just check requirements and exit
    check_requirements
  elif [[ "$INSTALL_ALL" == true ]]; then
    # Run complete setup non-interactively
    log "INFO" "Starting complete automated setup..."
    check_homebrew
    setup_directories
    install_dependencies
    install_node_tools
    install_bun
    setup_zoxide
    setup_git_config
    setup_aliases
    log "SUCCESS" "Complete setup finished!"
    echo ""
    echo -e "${GREEN}Please reload your shell:${NC}"
    echo "source \$HOME/.$DETECTED_SHELL""rc"
  elif [[ "$INSTALL_DEPS" == true ]] || [[ "$INSTALL_NODE" == true ]] || \
       [[ "$INSTALL_BUN_FLAG" == true ]] || [[ "$SETUP_GIT" == true ]] || \
       [[ "$SETUP_GIT_USER" == true ]] || [[ "$SETUP_GIT_SETTINGS" == true ]] || \
       [[ "$SETUP_ALIASES_FLAG" == true ]] || [[ "$SETUP_DIRS" == true ]] || \
       [[ "$SETUP_ZOXIDE_FLAG" == true ]]; then
    # Execute selected components
    check_homebrew
    execute_components
    echo ""
    echo -e "${GREEN}Selected components installed!${NC}"
    echo "Please reload your shell:"
    echo "source \$HOME/.$DETECTED_SHELL""rc"
  else
    # Show interactive menu (default)
    check_homebrew
    show_main_menu
  fi

  # Print completion message
  log_separator
}

# Run main function
main "$@"
