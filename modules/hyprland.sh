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

    # Setup configuration
    setup_hyprland_config

    return 0
}

install_hyprland_dependencies() {
    log_step "Installing DWM dependencies"

    local packages=()
    mapfile -t packages < <(load_package_list "$OS" "hyprland")

    for pkg in "${packages[@]}"; do
        if [[ -n "$pkg" ]] && [[ ! "$pkg" =~ ^# ]]; then
            install_package "$pkg"
        fi
    done
}

setup_hyprland_config() {
    log_step "Setting up Hyprland configuration"

    local hyprland_config_dir="$SCRIPT_DIR/hyprland"
    local target_config_dir="$HOME/.config/hypr"

    if [[ ! -d "$hyprland_config_dir" ]]; then
        log_warning "Hyprland config directory not found: $hyprland_config_dir"
        return 1
    fi

    # Link DWM configuration
    create_symlink "$hyprland_config_dir" "$target_config_dir" "Linking Hyprland configuration"

    # Link dwmscripts
    # local hyprland_scripts_src="$hyprland_config_dir/scripts"
    # local hyprland_scripts_dest="$HOME/.local/bin/dwmscripts"

    # if [[ -d "$dwmscripts_src" ]]; then
    #     create_symlink "$dwmscripts_src" "$dwmscripts_dest" "Linking DWM scripts"

    #     # Make scripts executable
    #     if ! $DRY_RUN; then
    #         find "$dwmscripts_src" -type f -exec chmod +x {} \;
    #     fi
    # fi
}

