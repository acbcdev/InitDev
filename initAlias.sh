#!/bin/bash

# Script: initAlias.sh
# Description: Initialize and manage aliases for zsh shell
# Author: ACBC
# Last Modified: 2025-01-30

# set -e # Exit on error
# set -u # Exit on undefined variable

# Configuration
ZSHRC="${HOME}/.zshrc"
BACKUP_DIR="${HOME}/.zshrc_backups"
VERBOSE=true

# Helper functions
log() {
  local level=$1
  shift
  local message=$*
  if [ "$VERBOSE" = true ] || [ "$level" = "ERROR" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message"
  fi
}

# Help message
show_help() {
  cat <<EOF
Usage: $SCRIPT_NAME [OPTIONS]
Initialize development aliases and configurations.

Options:
    -v, --verbose    Unenable verbose logging
    -h, --help       Show this help message
    -V, --version    Show version information

Examples:
    $SCRIPT_NAME --verbose
    $SCRIPT_NAME --help
EOF
}

create_backup() {
  local backup_file="${BACKUP_DIR}/zshrc_$(date '+%Y%m%d_%H%M%S').bak"
  mkdir -p "$BACKUP_DIR"
  cp "$ZSHRC" "$backup_file"
  log "INFO" "Created backup at $backup_file"
}

add_alias_if_not_exist() {
  local new_alias=$1
  local alias_name

  # Skip empty lines and comments
  [[ "$new_alias" =~ ^[[:space:]]*$ || "$new_alias" =~ ^[[:space:]]*# ]] && return

  # Extract alias name
  alias_name=$(echo "$new_alias" | grep -oE "^alias \S+=" || echo "")

  if [ -z "$alias_name" ]; then
    log "WARN" "Invalid alias format: $new_alias"
    return
  fi

  # Check if alias already exists
  if grep -q "^${alias_name}" "$ZSHRC" 2>/dev/null; then
    log "INFO" "Alias ${alias_name#alias } already exists"
  else
    echo "$new_alias" >>"$ZSHRC"
    log "INFO" "Added alias ${alias_name#alias }"
  fi
}

parse_arguments() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -v | --verbose)
      VERBOSE=false
      log "INFO" "Verbose mode enabled"
      shift
      ;;
    -h | --help)
      show_help
      exit 0
      ;;
    *)
      log "ERROR" "Unknown option: $1"
      show_help
      exit 1
      ;;
    esac
  done
}

# Main alias definitions
declare -a ALIASES=(
  "# ----General Aliases----"
  "alias enableNeoCode='sudo chown -R $USER /usr/share/code/'"
  "alias adios='poweroff'"
  "alias spdt='speedtest-cli'"
  "alias le='exa --level=1 --tree --icons'"
  "alias lr='exa --tree --level=1 --all --icons'"
  "# ----Package Manager Aliases----"
  "alias bund='bun dev'"
  "alias bunb='bun run build'"
  "alias bunf='bun run format'"
  "alias bunt='bun run test'"
  "alias bunr='bun run'"
  "alias buns='bun run start'"
  "alias buni='bun i'"
  "alias bunp='bun run preview'"
  "alias pnpmx='pnpm dlx'"
  "alias pnpmd='pnpm run dev'"
  "alias pnpmb='pnpm run build'"
  "alias pnpms='pnpm run start'"
  "alias pnpmt='pnpm run test'"
  "alias pnpmr='pnpm run'"
  "alias pnpmp='pnpm preview'"
  "alias pnpmi='pnpm install'"
  "alias npmd='npm run dev'"
  "alias npmb='npm run build'"
  "alias npms='npm run start'"
  "alias npmt='npm run test'"
  "alias npmr='npm run'"
  "alias npmi='npm install'"
  "alias xUnlighthouse='pnpm dlx unlighthouse --site'"
  "alias checkNodeVersion='pnpmx is-my-node-vulnerable'"

  "# ----Navigation Aliases----"
  "alias cl='clear'"
  "alias neo='fastfetch'"
  "alias toUpdate='sudo dnf update'"
  "alias toInstall='toUpdate && sudo dnf install'"
  "alias pl='ping 8.8.8.8'"
  "alias cb='cd ..'"
  "alias cbb='cd ../..'"
  "alias lg='lazygit'"
  "alias rgr='ranger'"
  "alias rmf='rm -rf'"

  "# ----Directory Shortcuts----"
  "alias this='code .'"
  "alias anti='antigravity .'"
  "alias hm='cd ~'"
  "alias hd='cd ~/Dev/'"
  "alias hi='cd ~/Imágenes'"
  "alias hw='cd ~/Descargas'"
  "alias hdo='cd ~/Documentos'"
  "alias projs='cd ~/Dev/projects/'"
  "alias study='cd ~/Dev/platzi/'"
  "alias OpenSrc='cd ~/Dev/cmt'"
  "alias prueba='cd ~/Dev/try'"

  "# ----Git Aliases----"
  "alias ggclone='git clone'"
  "alias ggcmt='git commit -am'"
  "alias ggadd='git add .'"
  "alias ggsta='git status'"
  "alias gglog='git log'"
  "alias ggswi='git switch'"

  "# ----System Aliases----"
  "alias reload='source $HOME/.zshrc'"
  "alias btop='bpytop'"
  "alias python='python3'"

  "# ----Ollama Aliases----"
  "alias ol='ollama'"
  "alias olr='ollama run'"
  "alias oll='ollama list'"
  "alias olp='ollama ps'"
  "alias ols='ollama stop'"
  "alias olrm='ollama rm'"

  "# ---- Init Apps ----"
  "eval "$(zoxide init zsh)"
  "eval "$(fnm env)"
)

# Main execution
main() {
  # Check if zshrc exists and is writable
  if [ ! -f "$ZSHRC" ]; then
    log "ERROR" "File $ZSHRC does not exist"
    exit 1
  fi

  # Create backup before making changes
  create_backup

  # Process each alias
  local count=0
  for alias_def in "${ALIASES[@]}"; do
    add_alias_if_not_exist "$alias_def"
    ((count++))
  done

  log "INFO" "Successfully processed $count aliases"
  log "INFO" "To apply changes, run: source $ZSHRC"
}

# Run main function
parse_arguments "$@"
main
