#!/usr/bin/env bash

# Base system setup module

module_base() {
    log_step "Setting up base system"

    # Install AUR helper
    if ! install_aur_helper; then
        log_error "Failed to install AUR helper"
        return 1
    fi

    # Install base packages
    if ! install_base_packages; then
        log_error "Failed to install base packages"
        return 1
    fi

    return 0
}

install_base_packages() {
    log_step "Installing base packages"

    local packages=()
    # Load packages using the unified loader
    if ! load_package_list "base" > /dev/null; then
        log_error "Failed to load package list"
        return 1
    fi

    mapfile -t packages < <(load_package_list "base")

    local installed_count=0
    local total_count=0

    for pkg in "${packages[@]}"; do
        if [[ -n "$pkg" ]]; then
            ((total_count++))
            if install_package "$pkg"; then
                ((installed_count++))
            fi
        fi
    done

    log_success "Installed $installed_count of $total_count base packages"
}
