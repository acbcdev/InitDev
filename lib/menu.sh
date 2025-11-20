#!/bin/bash

###############################################################################
# Menu Module - Interactive Menu System
###############################################################################

###############################################################################
# Display main interactive menu
###############################################################################
show_main_menu() {
  echo ""
  echo -e "${BLUE}=== InitDev Setup Menu ===${NC}"
  echo ""

  select choice in "Install Dependencies" "Install Node.js Tools" "Install Bun" "Configure Git" "Setup Aliases" "Create Directories" "Setup Zoxide" "Run Complete Setup" "View Log" "Exit"; do
    case $choice in
      "Install Dependencies")
        install_dependencies
        ;;
      "Install Node.js Tools")
        install_node_tools
        ;;
      "Install Bun")
        install_bun
        ;;
      "Configure Git")
        setup_git_config
        ;;
      "Setup Aliases")
        setup_aliases
        ;;
      "Create Directories")
        setup_directories
        ;;
      "Setup Zoxide")
        setup_zoxide
        ;;
      "Run Complete Setup")
        run_complete_setup
        ;;
      "View Log")
        if [ -f "$LOG_FILE" ]; then
          less "$LOG_FILE"
        else
          log "WARN" "Log file not found"
        fi
        ;;
      "Exit")
        log "INFO" "Exiting InitDev"
        break
        ;;
      *)
        log "WARN" "Invalid option"
        ;;
    esac

    echo ""
    echo -e "${BLUE}=== InitDev Setup Menu ===${NC}"
    echo ""
  done
}

###############################################################################
# Run complete setup sequence
###############################################################################
run_complete_setup() {
  log "INFO" "Starting complete setup..."

  setup_directories
  install_dependencies
  check_homebrew
  install_node_tools
  install_bun
  setup_zoxide
  setup_git_config
  setup_aliases

  log "SUCCESS" "Complete setup finished!"
  echo ""
  echo -e "${GREEN}Please run the following command to apply changes:${NC}"
  echo "source \$HOME/.$DETECTED_SHELL""rc"
}
