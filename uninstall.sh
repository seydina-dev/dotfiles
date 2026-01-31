#!/usr/bin/env bash

# Dotfiles uninstall script

set -eo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LIB_DIR="$SCRIPT_DIR/lib"

source "$LIB_DIR/logger.sh"
source "$LIB_DIR/colors.sh"
source "$LIB_DIR/helpers.sh"

DRY_RUN=false
BACKUP_RESTORE=false

usage() {
    cat << EOF
${BOLD}Dotfiles Uninstaller${RESET}

Usage: $(basename "$0") [OPTIONS]

Options:
  -h, --help          Show this help message
  -d, --dry-run       Show what would be removed without making changes
  -r, --restore       Restore from latest backup
  -f, --force         Skip confirmation prompts

${RED}Warning:${RESET} This will remove dotfiles and configurations!
EOF
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                usage
                exit 0
                ;;
            -d|--dry-run)
                DRY_RUN=true
                log_warning "DRY RUN MODE: No changes will be made"
                shift
                ;;
            -r|--restore)
                BACKUP_RESTORE=true
                shift
                ;;
            -f|--force)
                FORCE=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
}

# --- Signal Handling ---
cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 && $exit_code -ne 130 ]]; then
        log_error "Uninstallation interrupted or failed (Exit code: $exit_code)"
    fi
    
    log_debug "Cleaning up..."
}

handle_interrupt() {
    echo -e "\n"
    log_warning "Uninstallation interrupted by user. Aborting..."
    exit 130
}

trap cleanup EXIT
trap handle_interrupt INT TERM

find_latest_backup() {
    local backup_pattern="$HOME/.dotfiles.backup.*"
    local latest_backup=""

    # Get the most recent directory matching the pattern
    latest_backup=$(ls -d $backup_pattern 2>/dev/null | tail -n 1)
    echo "$latest_backup"
}

restore_backup() {
    local backup_dir
    backup_dir=$(find_latest_backup)

    if [[ -z "$backup_dir" ]]; then
        log_error "No backup found to restore"
        return 1
    fi

    log_header "Restoring from backup: $(basename "$backup_dir")"

    if ! $FORCE && ! confirm "Restore files from backup?"; then
        log_info "Restore cancelled"
        return 0
    fi

    local count=0
    while IFS= read -r -d '' file; do
        local rel_path="${file#$backup_dir/}"
        local target="$HOME/$rel_path"

        if $DRY_RUN; then
            log_info "[DRY RUN] Would restore: $rel_path → $target"
        else
            mkdir -p "$(dirname "$target")"
            if cp -r "$file" "$target"; then
                log_success "Restored: $rel_path"
                ((count++))
            else
                log_error "Failed to restore: $rel_path"
            fi
        fi
    done < <(find "$backup_dir" -type f -print0)

    log_success "Restored $count files from backup"
}

remove_symlinks() {
    log_step "Removing symbolic links"

    local symlinks_file="$SCRIPT_DIR/setup/symlinks.conf"
    local count=0

    if [[ ! -f "$symlinks_file" ]]; then
        log_error "Symlinks config not found"
        return 1
    fi

    while IFS=: read -r source target description category; do
        [[ "$source" =~ ^#.* ]] || [[ -z "$source" ]] && continue

        local full_target="${target/#\~/$HOME}"

        if [[ -L "$full_target" ]]; then
            if $DRY_RUN; then
                log_info "[DRY RUN] Would remove symlink: $full_target"
            else
                if rm "$full_target"; then
                    log_success "Removed: $full_target"
                    ((count++))
                else
                    log_error "Failed to remove: $full_target"
                fi
            fi
        fi
    done < "$symlinks_file"

    log_success "Removed $count symbolic links"
}

remove_custom_scripts() {
    log_step "Removing custom scripts"

    local scripts_src="$SCRIPT_DIR/custom-scripts"
    local scripts_dest="$HOME/.local/bin"
    local count=0

    if [[ ! -d "$scripts_src" ]]; then
        log_warning "Custom scripts directory not found"
        return 0
    fi

    while IFS= read -r -d '' script; do
        local script_name=$(basename "$script")
        local script_path="$scripts_dest/$script_name"

        if [[ -L "$script_path" ]]; then
            if $DRY_RUN; then
                log_info "[DRY RUN] Would remove script symlink: $script_name"
            else
                if rm "$script_path"; then
                    log_success "Removed: $script_name"
                    ((count++))
                else
                    log_error "Failed to remove: $script_name"
                fi
            fi
        fi
    done < <(find "$scripts_src" -type f -print0)

    log_success "Removed $count custom scripts"
}

remove_dwm() {
    log_step "Removing DWM installation"

    local dwm_files=(
        "/usr/local/bin/dwm"
        "/usr/local/bin/dmenu"
        "/usr/local/bin/st"
        "$HOME/.config/dwm"
        "$HOME/.dwm"
        "$HOME/.local/bin/dwmscripts"
    )

    local count=0
    for file in "${dwm_files[@]}"; do
        if [[ -e "$file" ]]; then
            if $DRY_RUN; then
                log_info "[DRY RUN] Would remove: $file"
            else
                if rm -rf "$file"; then
                    log_success "Removed: $file"
                    ((count++))
                else
                    log_warning "Failed to remove: $file"
                fi
            fi
        fi
    done

    log_success "Removed $count DWM files"
}

show_remaining_manual_steps() {
    log_header "Manual Cleanup Steps"

    cat << EOF
${YELLOW}The following may need manual cleanup:${RESET}

${BOLD}Package Management:${RESET}
  - Remove installed packages manually using your package manager.

${BOLD}Shell Configuration:${RESET}
  - Review and clean up ~/.bashrc, ~/.zshrc if they contain leftover sources.

${BOLD}Directories:${RESET}
  - Remove backup directories: ${HOME}/.dotfiles.backup.*
  - Remove log directory: ${HOME}/.local/state/dotfiles

${BOLD}Services:${RESET}
  - Disable services if no longer needed.

${GREEN}Most dotfiles have been removed. Review the above for complete cleanup.${RESET}
EOF
}

main() {
    log_header "Dotfiles Uninstallation"

    # Set OS global for helper functions
    OS=$(detect_os)

    if ! $FORCE && ! confirm "${BOLD_RED}This will remove your dotfiles configuration. Continue?${RESET}"; then
        log_info "Uninstallation cancelled"
        exit 0
    fi

    if $BACKUP_RESTORE; then
        restore_backup
    fi

    remove_symlinks
    remove_custom_scripts
    remove_dwm

    if ! $BACKUP_RESTORE; then
        show_remaining_manual_steps
    fi

    log_success "Uninstallation completed"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    parse_arguments "$@"
    main
fi
