#!/bin/bash

###############################################################################
# Logging Module - Centralized logging for InitDev
###############################################################################

# Color codes for better UX
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Configuration
LOG_FILE="${HOME}/.initdev_log"

###############################################################################
# Log to file and console with timestamp
# Terminal: Simple emoji/arrow prefix (clean output)
# Logs: Full format with timestamp and level
###############################################################################
log() {
  local level=$1
  shift
  local message=$*
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  local log_message="[$timestamp] [$level] $message"

  # Write to log file with full format
  echo "$log_message" >> "$LOG_FILE"

  # Print to console with simple prefix (no brackets on terminal)
  case "$level" in
    INFO)
      echo -e "${BLUE}▶${NC} $message"
      ;;
    SUCCESS)
      echo -e "${GREEN}✓${NC} $message"
      ;;
    WARN)
      echo -e "${YELLOW}!${NC} $message"
      ;;
    ERROR)
      echo -e "${RED}✗${NC} $message"
      ;;
  esac
}

###############################################################################
# Initialize log file
###############################################################################
init_log() {
  > "$LOG_FILE"
  log "INFO" "=========================================="
  log "INFO" "InitDev Setup Started"
  log "INFO" "=========================================="
}

###############################################################################
# Print log separator
###############################################################################
log_separator() {
  log "INFO" "=========================================="
  log "INFO" "InitDev Setup Completed"
  log "INFO" "=========================================="
  log "INFO" "Log saved to: $LOG_FILE"
}
