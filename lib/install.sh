#!/bin/bash

###############################################################################
# Installation Module - Package and Tool Installation
###############################################################################

###############################################################################
# Install core dependencies
###############################################################################
install_dependencies() {
  log "INFO" "Starting dependency installation..."

  # List of essential tools
  local brew_packages=(
    "curl"
    "git"
    "ranger"
    "zoxide"
    "exa"
    "fastfetch"
    "lazygit"
    "gh"
    "nvim"
  )

  log "INFO" "Installing brew packages..."
  for package in "${brew_packages[@]}"; do
    if brew list "$package" &>/dev/null; then
      log "INFO" "$package is already installed"
    else
      log "INFO" "Installing $package..."
      if brew install "$package"; then
        log "SUCCESS" "$package installed"
      else
        log "WARN" "Failed to install $package"
      fi
    fi
  done

  log "SUCCESS" "Dependency installation completed"
}

###############################################################################
# Install Node.js tools
###############################################################################
install_node_tools() {
  log "INFO" "Installing Node.js tools..."

  # Install fnm (Fast Node Manager)
  if ! command -v fnm &> /dev/null; then
    log "INFO" "Installing fnm..."
    brew install fnm
  fi

  # Initialize fnm in shell
  if [[ "$DETECTED_SHELL" == "zsh" ]]; then
    if ! grep -q "fnm env" "$SHELL_RC"; then
      echo 'eval "$(fnm env --use-on-cd)"' >> "$SHELL_RC"
      log "SUCCESS" "fnm initialization added to .zshrc"
    fi
  elif [[ "$DETECTED_SHELL" == "bash" ]]; then
    if ! grep -q "fnm env" "$SHELL_RC"; then
      echo 'eval "$(fnm env --use-on-cd)"' >> "$SHELL_RC"
      log "SUCCESS" "fnm initialization added to .bashrc"
    fi
  fi

  # Install Node.js LTS
  log "INFO" "Installing Node.js LTS..."
  fnm install --lts
  fnm default lts-latest

  # Install pnpm globally
  log "INFO" "Installing pnpm..."
  npm install -g pnpm

  log "SUCCESS" "Node.js tools installed"
}

###############################################################################
# Install Bun
###############################################################################
install_bun() {
  log "INFO" "Installing Bun..."

  if ! command -v bun &> /dev/null; then
    curl -fsSL https://bun.sh/install | bash
    log "SUCCESS" "Bun installed"
  else
    log "INFO" "Bun is already installed"
  fi
}
