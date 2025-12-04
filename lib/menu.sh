#!/bin/bash

###############################################################################
# Menu Module - Interactive Menu System
###############################################################################

###############################################################################
# Process universal menu commands with aliases
# Returns: 0=continue loop, 1=break/exit, 2=execute menu option
###############################################################################
process_menu_input() {
  local input="$1"
  local menu_type="$2"
  
  case "$input" in
    help|-h|\?)
      show_contextual_help "$menu_type"
      return 0  # Continue loop
      ;;
    exit|quit|q)
      log "INFO" "Exiting InitDev"
      return 1  # Exit requested
      ;;
    back|-b|inicio|-i)
      if [[ "$menu_type" == "main" ]]; then
        log "INFO" "Already at main menu"
      else
        log "INFO" "Returning to main menu"
      fi
      return 1  # Back to main menu
      ;;
    menu|m)
      if [[ "$menu_type" == "main" ]]; then
        log "INFO" "Already at main menu"
      else
        log "INFO" "Going to main menu"
      fi
      return 1  # Go to main menu
      ;;
    status|-s)
      show_system_status
      return 0  # Continue loop
      ;;
    *)
      return 2  # Not a universal command, process as menu option
      ;;
  esac
}

###############################################################################
# Show contextual help based on current menu
###############################################################################
show_contextual_help() {
  local menu_type="$1"
  
  if [[ "$menu_type" == "main" ]]; then
    cat << 'EOF'

=== InitDev Main Menu Help ===

UNIVERSAL COMMANDS:
  help, -h, ?        Show this help
  exit, quit, q      Exit InitDev
  back, -b, inicio, -i  Return to main menu
  menu, m            Go to main menu
  status, -s         Show system status

MENU OPTIONS:
  1, deps, install   Install Dependencies
  2, node            Install Node.js Tools
  3, bun             Install Bun
  4, git             Configure Git
  5, aliases         Setup Aliases
  6, dirs            Create Directories
  7, zoxide          Setup Zoxide
  8, all, complete   Run Complete Setup
  9, log             View Log
  10, exit           Exit InitDev

EXAMPLES:
  Type "1" or "deps" to install dependencies
  Type "git" to go to Git configuration
  Type "-b" to return to main menu
  Type "q" to quit

EOF
  elif [[ "$menu_type" == "git" ]]; then
    cat << 'EOF'

=== Git Configuration Menu Help ===

UNIVERSAL COMMANDS:
  help, -h, ?        Show this help
  exit, quit, q      Exit InitDev
  back, -b, inicio, -i  Back to Main Menu
  menu, m            Go to main menu
  status, -s         Show system status

GIT OPTIONS:
  1, user            Configure Git User (Name/Email)
  2, settings        Configure Git Settings
  3, all             Configure Git (All)
  4, back, -b        Back to Main Menu

EXAMPLES:
  Type "1" or "user" to configure git user
  Type "settings" to configure git settings
  Type "-b" to go back to main menu

EOF
  fi
}

###############################################################################
# Validate and normalize menu choice input
###############################################################################
validate_menu_choice() {
  local input="$1"
  local menu_type="$2"
  
  if [[ "$menu_type" == "main" ]]; then
    case "$input" in
      1|deps|install|dependencies) echo "Install Dependencies" ;;
      2|node|nodejs) echo "Install Node.js Tools" ;;
      3|bun) echo "Install Bun" ;;
      4|git|configure) echo "Configure Git" ;;
      5|aliases) echo "Setup Aliases" ;;
      6|dirs|directories) echo "Create Directories" ;;
      7|zoxide) echo "Setup Zoxide" ;;
      8|all|complete|setup) echo "Run Complete Setup" ;;
      9|log|view) echo "View Log" ;;
      10|exit) echo "Exit" ;;
      *) return 1 ;;
    esac
  elif [[ "$menu_type" == "git" ]]; then
    case "$input" in
      1|user|name|email) echo "Configure Git User (Name/Email)" ;;
      2|settings|config) echo "Configure Git Settings" ;;
      3|all|complete) echo "Configure Git (All)" ;;
      4|back|menu) echo "Back to Main Menu" ;;
      *) return 1 ;;
    esac
  fi
}

###############################################################################
# Show system status (same as --check)
###############################################################################
show_system_status() {
  check_requirements
}

###############################################################################
# Display main interactive menu
###############################################################################
show_main_menu() {
  while true; do
    echo ""
    echo -e "${BLUE}=== InitDev Setup Menu ===${NC}"
    echo ""
    echo "1) Install Dependencies    2) Install Node.js Tools"
    echo "3) Install Bun             4) Configure Git"
    echo "5) Setup Aliases           6) Create Directories"
    echo "7) Setup Zoxide            8) Run Complete Setup"
    echo "9) View Log               10) Exit"
    echo ""
    echo -n "Select option [1-10] or type command: "
    read -r input
    
    # Convert to lowercase for case-insensitive matching
    input=$(echo "$input" | tr '[:upper:]' '[:lower:]')
    
    # Process universal commands first
    process_menu_input "$input" "main"
    case $? in
      0) continue ;;  # Help was shown, continue loop
      1) break ;;     # Exit requested
      2) ;;          # Continue to menu option processing
    esac
    
    # Validate and process menu choice
    choice=$(validate_menu_choice "$input" "main")
    if [[ -n "$choice" ]]; then
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
          show_git_submenu
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
      esac
    else
      log "WARN" "Invalid option: $input. Type 'help' for available commands."
    fi
  done
}

###############################################################################
# Show Git configuration submenu
###############################################################################
show_git_submenu() {
  while true; do
    echo ""
    echo -e "${BLUE}=== Git Configuration Menu ===${NC}"
    echo ""
    echo "1) Configure Git User (Name/Email)"
    echo "2) Configure Git Settings"
    echo "3) Configure Git (All)"
    echo "4) Back to Main Menu"
    echo ""
    echo -n "Select option [1-4] or type command: "
    read -r input
    
    # Convert to lowercase for case-insensitive matching
    input=$(echo "$input" | tr '[:upper:]' '[:lower:]')
    
    # Process universal commands first
    process_menu_input "$input" "git"
    case $? in
      0) continue ;;  # Help was shown, continue loop
      1) return ;;     # Exit requested (back to main menu)
      2) ;;          # Continue to menu option processing
    esac
    
    # Validate and process menu choice
    choice=$(validate_menu_choice "$input" "git")
    if [[ -n "$choice" ]]; then
      case $choice in
        "Configure Git User (Name/Email)")
          setup_git_user_config
          ;;
        "Configure Git Settings")
          setup_git_general_config
          ;;
        "Configure Git (All)")
          setup_git_config
          ;;
        "Back to Main Menu")
          break
          ;;
      esac
    else
      log "WARN" "Invalid option: $input. Type 'help' for available commands."
    fi
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
