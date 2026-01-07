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

    local package_manager
    package_manager=$(detect_package_manager)

    case $package_manager in
        pacman)
            install_arch_packages
            ;;
        apt)
            install_debian_packages
            ;;
        *)
            log_error "Unsupported package manager: $package_manager"
            return 1
            ;;
    esac
}

install_arch_packages() {
    local packages=()

    # Load packages using the fixed function
    if ! load_package_list "arch" "base"; then
        log_error "Failed to load package list"
        return 1
    fi

    mapfile -t packages < <(load_package_list "arch" "base")

    local installed_count=0
    local total_count=0

    for pkg in "${packages[@]}"; do
        if [[ -n "$pkg" ]] && [[ ! "$pkg" =~ ^# ]]; then
            ((total_count++))
            if install_package "$pkg"; then
                ((installed_count++))
            fi
        fi
    done

    log_success "Installed $installed_count of $total_count base packages"
}

# Fixed load_package_list function


# Alternative simpler implementation if awk issues persist
load_package_list_simple() {
    local os="$1"
    local category="$2"
    local config_file="$CONFIG_DIR/${os}-packages.conf"

    if [[ ! -f "$config_file" ]]; then
        log_error "Package config not found: $config_file"
        return 1
    fi

    # Use grep and sed instead of awk
    sed -n "/^\[$category\]/,/^\[/p" "$config_file" | \
    grep -v "^\[" | \
    grep -v "^#" | \
    grep -v "^$" | \
    awk '{print $1}'
}
