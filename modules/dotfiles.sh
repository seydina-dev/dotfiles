#!/usr/bin/env bash

# Dotfiles management module

module_dotfiles() {
    log_step "Managing dotfiles and configurations"

    # Backup existing dotfiles
    if ! backup_existing_dotfiles; then
        log_error "Failed to backup existing dotfiles"
        return 1
    fi

    # Create symbolic links
    if ! create_symlinks_from_config; then
        log_error "Failed to create symlinks"
        return 1
    fi

    # Install custom scripts
    if ! install_custom_scripts; then
        log_error "Failed to install custom scripts"
        return 1
    fi

    return 0
}

backup_existing_dotfiles() {
    log_step "Backing up existing dotfiles"

    local backup_list=(
        "$HOME/.bashrc"
        "$HOME/.zshrc"
        "$HOME/.vimrc"
        "$HOME/.aliasrc"
        "$HOME/.functionrc"
        "$HOME/.path_variablerc"
        "$HOME/.config/kitty"
        "$HOME/.config/gtk-3.0"
        "$HOME/.config/picom"
        "$HOME/.config/qt5ct"
        "$HOME/.config/sxhkd"
    )

    for item in "${backup_list[@]}"; do
        if [[ -e "$item" ]]; then
            backup_file "$item"
        fi
    done

    log_success "Backup completed: $BACKUP_DIR"
}

create_symlinks_from_config() {
    log_step "Creating symbolic links"

    local symlinks_file="$CONFIG_DIR/symlinks.conf"

    if [[ ! -f "$symlinks_file" ]]; then
        log_error "Symlinks config not found: $symlinks_file"
        return 1
    fi

    local count=0
    while IFS=: read -r source target description; do
        # Skip comments and empty lines
        [[ "$source" =~ ^#.* ]] || [[ -z "$source" ]] && continue

        # Resolve source path relative to script directory
        local full_source="$SCRIPT_DIR/$source"
        local full_target="$target"

        # Expand ~ in target path
        full_target="${full_target/#\~/$HOME}"

        if [[ -z "$description" ]]; then
            description="Linking $source → $target"
        fi

        if create_symlink "$full_source" "$full_target" "$description"; then
            ((count++))
        else
            log_warning "Failed to create symlink: $source → $target"
        fi
    done < "$symlinks_file"

    log_success "Created $count symbolic links"
    return 0
}

install_custom_scripts() {
    log_step "Installing custom scripts"

    local scripts_src="$SCRIPT_DIR/custom-scripts"
    local scripts_dest="$HOME/.local/bin"

    if [[ ! -d "$scripts_src" ]]; then
        log_warning "Custom scripts directory not found: $scripts_src"
        return 0
    fi

    execute "mkdir -p '$scripts_dest'" "Ensuring bin directory exists"

    local count=0
    while IFS= read -r -d '' script; do
        local script_name=$(basename "$script")
        local script_dest="$scripts_dest/$script_name"

        if [[ -x "$script" ]]; then
            if create_symlink "$script" "$script_dest" "Installing script: $script_name"; then
                ((count++))
            fi
        else
            log_debug "Skipping non-executable: $script_name"
        fi
    done < <(find "$scripts_src" -type f -executable -print0)

    log_success "Installed $count custom scripts"
    return 0
}

verify_symlinks() {
    log_step "Verifying symbolic links"

    local symlinks_file="$CONFIG_DIR/symlinks.conf"
    local broken_links=()

    while IFS=: read -r source target; do
        [[ "$source" =~ ^#.* ]] || [[ -z "$source" ]] && continue

        local full_target="${target/#\~/$HOME}"

        if [[ -L "$full_target" ]] && [[ ! -e "$full_target" ]]; then
            broken_links+=("$full_target")
        fi
    done < "$symlinks_file"

    if [[ ${#broken_links[@]} -gt 0 ]]; then
        log_warning "Found ${#broken_links[@]} broken symlinks"
        for link in "${broken_links[@]}"; do
            log_warning "  Broken: $link"
        done
        return 1
    else
        log_success "All symlinks are valid"
        return 0
    fi
}
