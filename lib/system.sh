#!/bin/bash

###############################################################################
# System Detection Module - OS and Shell Detection
###############################################################################

OS_TYPE=""
DETECTED_SHELL=""
SHELL_RC=""

###############################################################################
# Detect operating system
###############################################################################
detect_os() {
  OS_TYPE=$(uname -s)
  case "$OS_TYPE" in
    Darwin)
      log "INFO" "Detected macOS"
      ;;
    Linux)
      log "INFO" "Detected Linux"
      ;;
    *)
      log "ERROR" "Unsupported OS: $OS_TYPE"
      exit 1
      ;;
  esac
}

###############################################################################
# Detect current shell and set RC file
###############################################################################
detect_shell() {
  # Try to detect the user's current shell
  if [[ "$SHELL" == *"zsh"* ]]; then
    DETECTED_SHELL="zsh"
    SHELL_RC="$HOME/.zshrc"
  elif [[ "$SHELL" == *"bash"* ]]; then
    DETECTED_SHELL="bash"
    SHELL_RC="$HOME/.bashrc"
  else
    # Default to zsh if not detected
    DETECTED_SHELL="zsh"
    SHELL_RC="$HOME/.zshrc"
  fi

  log "INFO" "Detected shell: $DETECTED_SHELL ($SHELL_RC)"
}

###############################################################################
# Prompt user for Homebrew update
###############################################################################
prompt_brew_update() {
  # Skip if auto-update is disabled
  if [[ "$AUTO_UPDATE_BREW" == "false" ]]; then
    log "INFO" "Auto-update disabled, skipping Homebrew update"
    return 0
  fi

  echo -n "Would you like to update Homebrew? [Y/n]: "
  read -r response
  case "$response" in
    [nN][oO]|[nN])
      log "INFO" "Skipping Homebrew update"
      ;;
    *)
      log "INFO" "Updating Homebrew..."
      if brew update; then
        log "SUCCESS" "Homebrew updated successfully"
      else
        log "WARN" "Homebrew update failed"
      fi
      ;;
  esac
}

###############################################################################
# Check and install Homebrew
###############################################################################
check_homebrew() {
  if ! command -v brew &> /dev/null; then
    log "WARN" "Homebrew not found. Installing..."
    install_homebrew
  else
    log "SUCCESS" "Homebrew is installed"
    prompt_brew_update
  fi
}

###############################################################################
# Install Homebrew
###############################################################################
install_homebrew() {
  log "INFO" "Installing Homebrew..."

  if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    log "SUCCESS" "Homebrew installed successfully"
  else
    log "ERROR" "Failed to install Homebrew"
    exit 1
  fi
}

###############################################################################
# Validate system requirements
###############################################################################
validate_system() {
  log "INFO" "Validating system requirements..."

  # Check for curl
  if ! command -v curl &> /dev/null; then
    log "ERROR" "curl is required but not found"
    exit 1
  fi

  # Check for git
  if ! command -v git &> /dev/null; then
    log "WARN" "git not found, will be installed"
  fi

  log "SUCCESS" "System validation passed"
}
