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

${GREEN}Usage:${RESET} $(basename "$0") [OPTIONS]

${GREEN}Options:${RESET}
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

find_latest_backup() {
    local backup_pattern="$HOME/.dotfiles.backup.*"
    local latest_backup=""

    for backup in $backup_pattern; do
        if [[ -d "$backup" ]]; then
            latest_backup="$backup"
        fi
    done

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
        local filename=$(basename "$file")
        local target="$HOME/$filename"

        if $DRY_RUN; then
            log_info "[DRY RUN] Would restore: $filename → $target"
        else
            if cp -r "$file" "$target"; then
                log_success "Restored: $filename"
                ((count++))
            else
                log_error "Failed to restore: $filename"
            fi
        fi
    done < <(find "$backup_dir" -type f -print0)

    log_success "Restored $count files from backup"
}

remove_symlinks() {
    log_step "Removing symbolic links"

    local symlinks_file="$SCRIPT_DIR/config/symlinks.conf"
    local count=0

    if [[ ! -f "$symlinks_file" ]]; then
        log_error "Symlinks config not found"
        return 1
    fi

    while IFS=: read -r source target; do
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

    local scripts_dir="$HOME/.local/bin"
    local custom_scripts=(
        "ani" "dad" "elbin" "ffcompress" "findd" "fzftest" "leb" "mdisk"
        "mountdisk" "mountjutsu" "mountphone" "move" "mphone" "notflix"
        "play" "record" "rmcl" "rmd" "screen" "screenManager" "senflix"
        "setbg" "setwal" "smci" "udisk" "umountphone" "uphone" "vimv"
    )

    local count=0
    for script in "${custom_scripts[@]}"; do
        local script_path="$scripts_dir/$script"

        if [[ -L "$script_path" ]] || [[ -f "$script_path" ]]; then
            if $DRY_RUN; then
                log_info "[DRY RUN] Would remove: $script"
            else
                if rm -f "$script_path"; then
                    log_success "Removed: $script"
                    ((count++))
                else
                    log_error "Failed to remove: $script"
                fi
            fi
        fi
    done

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
        "$HOME/.xinitrc"
        "$HOME/.Xresources"
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
  - Remove installed packages manually:
    paru -Rns $(paru -Qq)

${BOLD}Shell Configuration:${RESET}
  - Remove PATH modifications from:
    ~/.bashrc, ~/.zshrc, ~/.profile

${BOLD}Directories:${RESET}
  - Remove backup directories: ${HOME}/.dotfiles.backup.*
  - Remove log directory: ${HOME}/.local/state/dotfiles

${BOLD}Services:${RESET}
  - Disable services if no longer needed:
    sudo systemctl disable NetworkManager bluetooth sshd

${GREEN}Most dotfiles have been removed. Review the above for complete cleanup.${RESET}
EOF
}

main() {
    log_header "Dotfiles Uninstallation"

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
fi#!/usr/bin/env bash

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

${GREEN}Usage:${RESET} $(basename "$0") [OPTIONS]

${GREEN}Options:${RESET}
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

find_latest_backup() {
    local backup_pattern="$HOME/.dotfiles.backup.*"
    local latest_backup=""

    for backup in $backup_pattern; do
        if [[ -d "$backup" ]]; then
            latest_backup="$backup"
        fi
    done

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
        local filename=$(basename "$file")
        local target="$HOME/$filename"

        if $DRY_RUN; then
            log_info "[DRY RUN] Would restore: $filename → $target"
        else
            if cp -r "$file" "$target"; then
                log_success "Restored: $filename"
                ((count++))
            else
                log_error "Failed to restore: $filename"
            fi
        fi
    done < <(find "$backup_dir" -type f -print0)

    log_success "Restored $count files from backup"
}

remove_symlinks() {
    log_step "Removing symbolic links"

    local symlinks_file="$SCRIPT_DIR/config/symlinks.conf"
    local count=0

    if [[ ! -f "$symlinks_file" ]]; then
        log_error "Symlinks config not found"
        return 1
    fi

    while IFS=: read -r source target; do
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

    local scripts_dir="$HOME/.local/bin"
    local custom_scripts=(
        "ani" "dad" "elbin" "ffcompress" "findd" "fzftest" "leb" "mdisk"
        "mountdisk" "mountjutsu" "mountphone" "move" "mphone" "notflix"
        "play" "record" "rmcl" "rmd" "screen" "screenManager" "senflix"
        "setbg" "setwal" "smci" "udisk" "umountphone" "uphone" "vimv"
    )

    local count=0
    for script in "${custom_scripts[@]}"; do
        local script_path="$scripts_dir/$script"

        if [[ -L "$script_path" ]] || [[ -f "$script_path" ]]; then
            if $DRY_RUN; then
                log_info "[DRY RUN] Would remove: $script"
            else
                if rm -f "$script_path"; then
                    log_success "Removed: $script"
                    ((count++))
                else
                    log_error "Failed to remove: $script"
                fi
            fi
        fi
    done

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
        "$HOME/.xinitrc"
        "$HOME/.Xresources"
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
  - Remove installed packages manually:
    paru -Rns $(paru -Qq)

${BOLD}Shell Configuration:${RESET}
  - Remove PATH modifications from:
    ~/.bashrc, ~/.zshrc, ~/.profile

${BOLD}Directories:${RESET}
  - Remove backup directories: ${HOME}/.dotfiles.backup.*
  - Remove log directory: ${HOME}/.local/state/dotfiles

${BOLD}Services:${RESET}
  - Disable services if no longer needed:
    sudo systemctl disable NetworkManager bluetooth sshd

${GREEN}Most dotfiles have been removed. Review the above for complete cleanup.${RESET}
EOF
}

main() {
    log_header "Dotfiles Uninstallation"

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
