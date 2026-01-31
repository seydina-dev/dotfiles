#!/usr/bin/env bash

# Hyprland window manager module

module_hyprland() {
    log_step "Setting up Hyprland window manager"

    if [[ "$OS" != "arch" ]]; then
        log_warning "Hyprland setup is optimized for Arch Linux. Proceeding with caution."
    fi

    # Install Hyprland dependencies
    if ! install_hyprland_dependencies; then
        log_error "Failed to install Hyprland dependencies"
        return 1
    fi

    # Setup configuration using the category filter
    if ! create_symlinks_from_config "hyprland"; then
        log_error "Failed to setup Hyprland configuration"
        return 1
    fi

    return 0
}

install_hyprland_dependencies() {
    log_step "Installing Hyprland dependencies"

    local packages=()
    mapfile -t packages < <(load_package_list "hyprland")

    for pkg in "${packages[@]}"; do
        if [[ -n "$pkg" ]]; then
            install_package "$pkg"
        fi
    done
}
