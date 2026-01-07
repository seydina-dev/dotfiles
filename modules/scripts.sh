#!/usr/bin/env bash

# Custom scripts module

module_scripts() {
    log_step "Setting up custom scripts"

    if ! install_custom_scripts; then
        log_error "Failed to install custom scripts"
        return 1
    fi

    if ! setup_bin_directory; then
        log_error "Failed to setup bin directory"
        return 1
    fi

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

        # Skip if it's a directory
        if [[ -d "$script" ]]; then
            continue
        fi

        # Ensure script is executable
        if [[ ! -x "$script" ]]; then
            log_debug "Making script executable: $script_name"
            execute "chmod +x '$script'" "Making script executable: $script_name"
        fi

        # Create symlink or copy the script
        if create_symlink "$script" "$script_dest" "Installing script: $script_name"; then
            ((count++))
        else
            log_warning "Failed to install script: $script_name"
        fi
    done < <(find "$scripts_src" -type f -print0 2>/dev/null)

    log_success "Installed $count custom scripts"
    return 0
}

verify_script_installation() {
    log_step "Verifying script installation"

    local scripts_src="$SCRIPT_DIR/custom-scripts"
    local scripts_dest="$HOME/.local/bin"
    local missing_scripts=()

    if [[ ! -d "$scripts_src" ]]; then
        return 0
    fi

    while IFS= read -r -d '' script; do
        local script_name=$(basename "$script")
        local script_dest="$scripts_dest/$script_name"

        if [[ ! -e "$script_dest" ]]; then
            missing_scripts+=("$script_name")
        elif [[ ! -x "$script_dest" ]]; then
            log_warning "Script not executable: $script_name"
        fi
    done < <(find "$scripts_src" -type f -print0 2>/dev/null)

    if [[ ${#missing_scripts[@]} -gt 0 ]]; then
        log_warning "Missing script symlinks: ${missing_scripts[*]}"
        return 1
    else
        log_success "All custom scripts are properly installed"
        return 0
    fi
}

setup_bin_directory() {
    log_step "Setting up local bin directory"

    local bin_dir="$HOME/.local/bin"
    local profile_files=("$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile")

    execute "mkdir -p '$bin_dir'" "Creating bin directory"

    # Ensure bin directory is in PATH
    for profile in "${profile_files[@]}"; do
        if [[ -f "$profile" ]]; then
            add_to_path "$bin_dir" "$profile"
        fi
    done

    # Verify PATH setup
    if ! echo "$PATH" | grep -q "$bin_dir"; then
        log_warning "Bin directory not in PATH. You may need to restart your shell."
    else
        log_success "Bin directory is in PATH"
    fi

    return 0
}

add_to_path() {
    local path_dir="$1"
    local profile_file="$2"
    local path_export="export PATH=\"$path_dir:\$PATH\""

    # Check if already in PATH
    if grep -q "$path_dir" "$profile_file" 2>/dev/null; then
        log_debug "PATH already configured in $(basename "$profile_file")"
        return 0
    fi

    log_substep "Adding to PATH in $(basename "$profile_file")"

    if $DRY_RUN; then
        log_debug "[DRY RUN] Would add to $profile_file: $path_export"
        return 0
    fi

    # Add to the file
    echo -e "\n# Added by dotfiles setup" >> "$profile_file"
    echo "$path_export" >> "$profile_file"
    log_success "Updated PATH in $(basename "$profile_file")"
}

list_installed_scripts() {
    log_step "Installed custom scripts:"

    local scripts_dest="$HOME/.local/bin"
    local scripts_src="$SCRIPT_DIR/custom-scripts"

    if [[ ! -d "$scripts_src" ]]; then
        log_info "No custom scripts found"
        return 0
    fi

    while IFS= read -r -d '' script; do
        local script_name=$(basename "$script")
        local script_dest="$scripts_dest/$script_name"

        if [[ -L "$script_dest" ]] && [[ -e "$script_dest" ]]; then
            log_success "  ✓ $script_name"
        elif [[ -e "$script_dest" ]]; then
            log_info "  ● $script_name (file)"
        else
            log_warning "  ✗ $script_name (missing)"
        fi
    done < <(find "$scripts_src" -type f -print0 2>/dev/null)
}
