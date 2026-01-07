#!/usr/bin/env bash

set -eo pipefail

# --- Core Configuration ---
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly MODULES_DIR="$SCRIPT_DIR/modules"
readonly LIB_DIR="$SCRIPT_DIR/lib"
readonly CONFIG_DIR="$SCRIPT_DIR/config"
readonly BACKUP_DIR="$HOME/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)"

# --- Source Core Libraries ---
source "$LIB_DIR/colors.sh"
source "$LIB_DIR/logger.sh"  # Source logger before other libs to ensure logging is available
source "$LIB_DIR/helpers.sh"
source "$LIB_DIR/validators.sh"

# --- Global State ---
DRY_RUN=false
VERBOSE=false
FORCE=false
declare -a EXECUTED_STEPS=()
declare -A INSTALLED_PACKAGES=()

# --- Usage Information ---
usage() {
    cat << EOF
${BOLD}Dotfiles Setup Manager${RESET}

${GREEN}Usage:${RESET} $(basename "$0") [OPTIONS]

${GREEN}Options:${RESET}
  -h, --help          Show this help message
  -d, --dry-run       Show what would be done without making changes
  -v, --verbose       Enable verbose output
  -f, --force         Skip confirmation prompts
  -m, --modules       Run specific modules (comma-separated)
  -s, --skip          Skip specific modules (comma-separated)
  --show-logs         Show recent log entries after setup

${GREEN}Available Modules:${RESET}
  base        Install base packages and dependencies
  dotfiles    Link dotfiles and configuration
  services    Enable system services
  dwm         Install DWM and window manager components
  fonts       Install fonts
  scripts     Install custom scripts

${GREEN}Examples:${RESET}
  $(basename "$0")                    # Full installation
  $(basename "$0") --dry-run          # Preview changes
  $(basename "$0") -m base,dotfiles   # Only run specific modules
  $(basename "$0") -s dwm,fonts       # Skip specific modules
EOF
}

# --- Argument Parsing ---
parse_arguments() {
    local modules=""
    local skip=""
    local show_logs=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                LOG_LEVEL=$LOG_DEBUG  # Set to debug level for verbose output
                shift
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            -m|--modules)
                modules="$2"
                shift 2
                ;;
            -s|--skip)
                skip="$2"
                shift 2
                ;;
            --show-logs)
                show_logs=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done

    # Module selection logic
    if [[ -n "$modules" ]]; then
        IFS=',' read -ra SELECTED_MODULES <<< "$modules"
    else
        SELECTED_MODULES=("base" "dotfiles" "services" "scripts" "fonts" "dwm")
    fi

    if [[ -n "$skip" ]]; then
        IFS=',' read -ra SKIP_MODULES <<< "$skip"
        for skip_module in "${SKIP_MODULES[@]}"; do
            SELECTED_MODULES=("${SELECTED_MODULES[@]/$skip_module}")
        done
    fi

    # Store show_logs in global if needed, or handle immediately
    if [[ "$show_logs" == true ]]; then
        SHOW_LOGS_AFTER=true
    else
        SHOW_LOGS_AFTER=false
    fi
}

# --- Module Loader ---
load_module() {
    local module="$1"
    local module_file="$MODULES_DIR/${module}.sh"

    if [[ ! -f "$module_file" ]]; then
        log_error "Module not found: $module"
        return 1
    fi

    log_debug "Loading module: $module"
    source "$module_file"
}

# --- Main Execution Flow ---
main() {
    # Initialize logging first
    if ! setup_logging; then
        echo "Warning: Failed to initialize file logging, continuing with console output only"
    fi

    log_header "Starting Dotfiles Setup"

    # Show log file location
    show_log_info

    # Pre-flight checks
    detect_os
    check_dependencies
    setup_directories

    # Load and execute modules
    for module in "${SELECTED_MODULES[@]}"; do
        if [[ -n "$module" ]]; then
            execute_module "$module"
        fi
    done

    # Post-installation verification
    verify_installations

    # Final summary
    show_summary
}

# --- Post-installation Verification ---
verify_installations() {
    log_step "Verifying installations"

    # Verify custom scripts if scripts module was executed
    if [[ " ${EXECUTED_STEPS[@]} " =~ " scripts " ]]; then
        load_module "scripts"
        if declare -f verify_script_installation > /dev/null; then
            verify_script_installation
        fi
    fi

    # Verify symlinks if dotfiles module was executed
    if [[ " ${EXECUTED_STEPS[@]} " =~ " dotfiles " ]]; then
        load_module "dotfiles"
        if declare -f verify_symlinks > /dev/null; then
            verify_symlinks
        fi
    fi
}

# --- Module Execution ---
execute_module() {
    local module="$1"

    log_section "Module: ${module^}"

    if ! load_module "$module"; then
        log_error "Failed to load module: $module"
        return 1
    fi

    local module_func="module_${module}"
    if declare -f "$module_func" > /dev/null; then
        if $DRY_RUN; then
            log_info "[DRY RUN] Would execute: $module_func"
        else
            if $FORCE || confirm "Run ${module} module?"; then
                log_step "Starting ${module} module..."
                if "$module_func"; then
                    EXECUTED_STEPS+=("$module")
                    log_success "Completed: $module"
                else
                    log_error "Failed: $module"
                    if ! confirm "Continue despite failure?"; then
                        exit 1
                    fi
                fi
            else
                log_info "Skipped: $module"
            fi
        fi
    else
        log_error "Module function not found: $module_func"
    fi
}

# --- Pre-flight Checks ---
check_dependencies() {
    local deps=("bash" "git")
    local missing=()

    for dep in "${deps[@]}"; do
        if ! command -v "$dep" > /dev/null; then
            missing+=("$dep")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing dependencies: ${missing[*]}"
        exit 1
    fi
}

setup_directories() {
    local dirs=("$(dirname "$BACKUP_DIR")" "$HOME/.local/bin" "$HOME/.config")

    for dir in "${dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            log_debug "Creating directory: $dir"
            mkdir -p "$dir"
        fi
    done
}

# --- Summary Report ---
show_summary() {
    log_header "Setup Complete"

    if [[ ${#EXECUTED_STEPS[@]} -eq 0 ]]; then
        log_info "No modules were executed"
        return
    fi

    log_success "Successfully executed ${#EXECUTED_STEPS[@]} modules:"
    for step in "${EXECUTED_STEPS[@]}"; do
        log_info "  ✓ $step"
    done

    if [[ ${#INSTALLED_PACKAGES[@]} -gt 0 ]]; then
        log_success "Installed ${#INSTALLED_PACKAGES[@]} packages"
    fi

    # Show log file location again for convenience
    show_log_info

    if $DRY_RUN; then
        log_warning "This was a dry run. No changes were made."
    else
        log_success "Dotfiles setup completed successfully!"
        log_info "Restart your shell or run: exec zsh"
    fi

    # Show recent logs if requested
    if [[ "${SHOW_LOGS_AFTER:-false}" == true ]]; then
        echo
        show_recent_logs 15
    fi
}

# --- Signal Handling ---
cleanup() {
    log_debug "Cleaning up..."
    # Add any cleanup tasks here
}

trap cleanup EXIT INT TERM

# --- Entry Point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    parse_arguments "$@"

    if $DRY_RUN; then
        log_warning "DRY RUN MODE: No changes will be made"
    fi

    if $VERBOSE; then
        log_debug "Verbose mode enabled"
    fi

    main
fi
