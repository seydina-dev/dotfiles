#!/usr/bin/env bash

# Logging system with colors and levels

# Global log file variable
LOG_FILE=""

# Initialize logging system
setup_logging() {
    local log_dir="${LOG_DIR:-$HOME/.local/state/dotfiles}"

    # Create log directory
    if ! mkdir -p "$log_dir" 2>/dev/null; then
        echo "Warning: Cannot create log directory $log_dir, using /tmp"
        log_dir="/tmp/dotfiles"
        mkdir -p "$log_dir"
    fi

    LOG_FILE="$log_dir/setup-$(date +%Y%m%d_%H%M%S).log"

    # Initialize log file
    if ! touch "$LOG_FILE" 2>/dev/null; then
        echo "Warning: Cannot write to log file $LOG_FILE, logging to stdout only"
        LOG_FILE=""
        return 1
    fi

    # Redirect output if possible
    if command -v tee >/dev/null && [[ -n "$LOG_FILE" ]]; then
        exec > >(tee -a "$LOG_FILE") 2>&1
    fi

    log_debug "Logging initialized: $LOG_FILE"
    return 0
}

# Check if logging is available
is_logging_available() {
    [[ -n "$LOG_FILE" ]] && [[ -f "$LOG_FILE" ]] && [[ -w "$LOG_FILE" ]]
}

# Log levels
readonly LOG_DEBUG=0
readonly LOG_INFO=1
readonly LOG_WARNING=2
readonly LOG_ERROR=3

LOG_LEVEL=${LOG_LEVEL:-$LOG_INFO}

log() {
    local level="$1"
    local message="$2"
    local color="$3"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local level_name=""

    case $level in
        $LOG_DEBUG) level_name="DEBUG" ;;
        $LOG_INFO) level_name="INFO" ;;
        $LOG_WARNING) level_name="WARN" ;;
        $LOG_ERROR) level_name="ERROR" ;;
    esac

    # Always output to terminal based on log level
    if [[ $level -ge $LOG_LEVEL ]]; then
        echo -e "${color}[$timestamp] [$level_name]${RESET} $message" >&2
    fi

    # Write to log file if available
    if is_logging_available; then
        echo "[$timestamp] [$level_name] $message" >> "$LOG_FILE"
    fi
}

# ... rest of logging functions remain the same
log_debug() { log $LOG_DEBUG "$1" "$GRAY"; }
log_info() { log $LOG_INFO "$1" "$BLUE"; }
log_success() { log $LOG_INFO "$1" "$GREEN"; }
log_warning() { log $LOG_WARNING "$1" "$YELLOW"; }
log_error() { log $LOG_ERROR "$1" "$RED"; }

log_header() {
    echo
    echo -e "${BOLD}${CYAN}## $1${RESET}"
    echo
}

log_section() {
    echo
    echo -e "${BOLD}${WHITE}➜ $1${RESET}"
}

log_step() {
    echo -e "${GREEN}▶${RESET} $1"
}

log_substep() {
    echo -e "  ${BLUE}•${RESET} $1"
}

# Get the current log file path
get_log_file() {
    echo "$LOG_FILE"
}

# Display log file location
show_log_info() {
    if is_logging_available; then
        log_info "Log file: $LOG_FILE"
    else
        log_warning "Logging to file is not available"
    fi
}
