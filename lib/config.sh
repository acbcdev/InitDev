#!/bin/bash

###############################################################################
# Configuration Module - Git, Aliases, Directories, and Shell Config
###############################################################################

# Configuration variables
readonly AUTO_UPDATE_BREW="${AUTO_UPDATE_BREW:-true}"

###############################################################################
# Setup Git user configuration (name and email only)
###############################################################################
setup_git_user_config() {
  log "INFO" "Setting up Git user configuration..."

  # Check if already configured
  if git config --global user.name &>/dev/null; then
    log "WARN" "Git user already configured as: $(git config --global user.name) <$(git config --global user.email)>"
    read -rp "Do you want to reconfigure user settings? (y/n): " reconfigure
    if [[ "$reconfigure" != "y" ]]; then
      log "INFO" "Skipping Git user configuration"
      return
    fi
  fi

  # Prompt for credentials
  read -rp "Enter your Git email: " git_email
  read -rp "Enter your Git name: " git_name

  # Validate email (basic check)
  if [[ ! "$git_email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    log "WARN" "Email format may be invalid: $git_email"
  fi

  # Set git user config
  git config --global user.email "$git_email"
  git config --global user.name "$git_name"

  log "SUCCESS" "Git user configuration completed"
}

###############################################################################
# Setup Git general configuration (settings only, no user config)
###############################################################################
setup_git_general_config() {
  log "INFO" "Setting up Git general configuration..."

  # Set git config (general settings)
  git config --global init.defaultBranch main
  git config --global core.editor "nvim"
  git config --global pull.rebase false
  git config --global alias.undo "reset --soft HEAD^"
  git config --global alias.rank "shortlog -sn --no-merges"

  # Setup global gitignore
  local gitignore_global="$HOME/.gitignore_global"
  if [ ! -f "$gitignore_global" ]; then
    cat >"$gitignore_global" <<'EOF'
# Environment variables
.env
.env.local
.env.*.local

# General
.DS_Store
.AppleDouble
.LSOverride

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Node
node_modules/
dist/
build/

# Dependencies
.bun
.fnm

# macOS specific
Icon
._*
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent
.AppleDB
.AppleDesktop
Network\ Trash\ Folder
Temporary\ Items
.apdisk
*.icloud
EOF
    git config --global core.excludesfile "$gitignore_global"
    log "SUCCESS" "Global gitignore created at $gitignore_global"
  else
    log "INFO" "Global gitignore already exists"
  fi

  log "SUCCESS" "Git general configuration completed"
}

###############################################################################
# Setup Git configuration (complete setup - user + general settings)
###############################################################################
setup_git_config() {
  log "INFO" "Setting up complete Git configuration..."

  # Setup user config first
  setup_git_user_config

  # Setup general config
  setup_git_general_config

  log "SUCCESS" "Complete Git configuration finished"
}

###############################################################################
# Setup shell aliases
###############################################################################
setup_aliases() {
  log "INFO" "Setting up shell aliases..."

  # Load aliases definition
  local aliases_file="${SCRIPT_DIR}/lib/aliases.sh"
  if [ ! -f "$aliases_file" ]; then
    log "ERROR" "Aliases file not found: $aliases_file"
    return 1
  fi
  source "$aliases_file"

  # Create/overwrite single fixed backup of shell config
  local backup_file="${HOME}/.${DETECTED_SHELL}rc.backup.init-alias"
  cp "$SHELL_RC" "$backup_file"
  log "SUCCESS" "Backup saved to $backup_file"

  local aliases_added=0
  local aliases_skipped=0
  local start_time=$SECONDS

  for alias_def in "${ALIASES[@]}"; do
    if [[ -z "$alias_def" ]]; then
      continue
    fi

    if [[ "$alias_def" =~ ^# ]]; then
      echo "$alias_def" >>"$SHELL_RC"
      continue
    fi

    local alias_name=$(echo "$alias_def" | grep -oE "^alias [^=]+" || echo "")

    if [ -n "$alias_name" ]; then
      if ! grep -q "^${alias_name}" "$SHELL_RC"; then
        echo "$alias_def" >>"$SHELL_RC"
        ((aliases_added++))
      else
        ((aliases_skipped++))
      fi
    fi
  done

  local elapsed=$(( SECONDS - start_time ))
  local total=$(( aliases_added + aliases_skipped ))

  echo ""
  echo -e "  ══════════════════════════════"
  echo -e "     ${BLUE}Alias Setup Stats${NC}"
  echo -e "  ══════════════════════════════"
  echo -e "  ${GREEN}✓${NC} Created:  $aliases_added"
  echo -e "  ${YELLOW}→${NC} Skipped:  $aliases_skipped"
  echo -e "  ${BLUE}─${NC} Total:    $total"
  echo -e "  ⏱  Time:    ${elapsed}s"
  echo -e "  ══════════════════════════════"
  echo ""

  log "SUCCESS" "Alias setup complete: $aliases_added created, $aliases_skipped skipped"
  log "INFO" "To apply aliases, run: source \$SHELL_RC"
}

###############################################################################
# Create development directory structure
###############################################################################
setup_directories() {
  log "INFO" "Creating development directories..."

  local directories=(
    "$HOME/Dev"
    "$HOME/Dev/projects"
    "$HOME/Dev/platzi"
    "$HOME/Dev/cmt"
    "$HOME/Dev/try"
  )

  for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
      log "INFO" "Directory already exists: $dir"
    else
      mkdir -p "$dir"
      log "SUCCESS" "Created directory: $dir"
    fi
  done
}

###############################################################################
# Setup zoxide smart navigation
###############################################################################
setup_zoxide() {
  log "INFO" "Setting up zoxide..."

  if ! grep -q "zoxide init" "$SHELL_RC"; then
    echo 'eval "$(zoxide init '$DETECTED_SHELL')"' >>"$SHELL_RC"
    log "SUCCESS" "Zoxide initialized in .$DETECTED_SHELL""rc"
  else
    log "INFO" "Zoxide already initialized"
  fi
}
