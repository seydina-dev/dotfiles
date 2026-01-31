#!/usr/bin/env bash

# Dotfiles management module

module_dotfiles() {
    log_step "Managing dotfiles and configurations"

    # Create symbolic links
    if ! create_symlinks_from_config; then
        log_error "Failed to create symlinks"
        return 1
    fi

    return 0
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

verify_symlinks() {
    log_step "Verifying symbolic links"

    local symlinks_file="$CONFIG_DIR/symlinks.conf"
    local broken_links=()

    while IFS=: read -r source target description; do
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
