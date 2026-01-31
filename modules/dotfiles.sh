#!/usr/bin/env bash

# Dotfiles management module

module_dotfiles() {
    log_step "Managing dotfiles and configurations"

    # Create symbolic links (only global category)
    if ! create_symlinks_from_config "global"; then
        log_error "Failed to create symlinks"
        return 1
    fi

    return 0
}

verify_symlinks() {
    log_step "Verifying symbolic links"

    local symlinks_file="$CONFIG_DIR/symlinks.conf"
    local broken_links=()

    if [[ ! -f "$symlinks_file" ]]; then
        log_error "Symlinks config not found: $symlinks_file"
        return 1
    fi

    while IFS=: read -r source target description category; do
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
