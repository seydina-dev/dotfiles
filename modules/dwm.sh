#!/usr/bin/env bash

# DWM window manager module

module_dwm() {
    log_step "Setting up DWM window manager"

    if [[ "$OS" != "arch" ]]; then
        log_warning "DWM setup is optimized for Arch Linux. Proceeding with caution."
    fi

    # Install DWM dependencies
    if ! install_dwm_dependencies; then
        log_error "Failed to install DWM dependencies"
        return 1
    fi

    # Clone and build DWM
    if ! build_dwm; then
        log_error "Failed to build DWM"
        return 1
    fi

    # Install additional components
    if confirm "Install DWM extra packages and fonts?"; then
        install_dwm_extras
        install_dwm_fonts
    fi

    # Setup configuration
    setup_dwm_config

    return 0
}

install_dwm_dependencies() {
    log_step "Installing DWM dependencies"

    local packages=()
    mapfile -t packages < <(load_package_list "dwm")

    for pkg in "${packages[@]}"; do
        if [[ -n "$pkg" ]]; then
            install_package "$pkg"
        fi
    done
}

build_dwm() {
    log_step "Building DWM from source"

    local dwm_repo="https://gitlab.com/sedev077/dwm.git"
    local build_dir="$HOME/.local/src/dwm"

    # Clone repository
    if [[ ! -d "$build_dir" ]]; then
        execute "git clone '$dwm_repo' '$build_dir'" "Cloning DWM repository"
    else
        execute "cd '$build_dir' && git pull" "Updating DWM repository"
    fi

    # Build and install
    execute "cd '$build_dir' && sudo make clean install" "Building DWM"

    if command -v dwm >/dev/null; then
        log_success "DWM installed successfully"
        return 0
    else
        log_error "DWM installation failed"
        return 1
    fi
}

install_dwm_extras() {
    log_step "Installing DWM extra packages"

    local extras=(
        "blueman"
        "bluez-utils"
        "imagemagick"
        "jq"
        "lsd"
        "network-manager-applet"
        "polkit-kde-agent"
        "sxiv"
        "thunar"
        "thunar-archive-plugin"
        "unclutter"
        "yt-dlp"
    )

    for pkg in "${extras[@]}"; do
        install_package "$pkg"
    done
}

install_dwm_fonts() {
    log_step "Installing DWM fonts"

    local fonts=()
    mapfile -t fonts < <(load_package_list "fonts")

    for font in "${fonts[@]}"; do
        if [[ -n "$font" ]]; then
            install_package "$font"
        fi
    done

    # Update font cache
    if command -v fc-cache >/dev/null; then
        execute "fc-cache -fv" "Updating font cache"
    fi
}

setup_dwm_config() {
    log_step "Setting up DWM configuration"

    local dwm_config_dir="$SCRIPT_DIR/dwm"
    local target_config_dir="$HOME/.config/dwm"

    if [[ ! -d "$dwm_config_dir" ]]; then
        log_warning "DWM config directory not found: $dwm_config_dir"
        return 1
    fi

    # Link DWM configuration
    create_symlink "$dwm_config_dir" "$target_config_dir" "Linking DWM configuration"

    # Link dwmscripts
    local dwmscripts_src="$dwm_config_dir/dwmscripts"
    local dwmscripts_dest="$HOME/.local/bin/dwmscripts"

    if [[ -d "$dwmscripts_src" ]]; then
        create_symlink "$dwmscripts_src" "$dwmscripts_dest" "Linking DWM scripts"

        # Make scripts executable
        if ! $DRY_RUN; then
            find "$dwmscripts_src" -type f -exec chmod +x {} \;
        fi
    fi

    # Link X11 configuration
    if [[ -f "$dwm_config_dir/.xinitrc" ]]; then
        create_symlink "$dwm_config_dir/.xinitrc" "$HOME/.xinitrc" "Linking Xinitrc"
    fi

    if [[ -f "$dwm_config_dir/.Xresources" ]]; then
        create_symlink "$dwm_config_dir/.Xresources" "$HOME/.Xresources" "Linking Xresources"
    fi
}

setup_dwm_autostart() {
    log_step "Setting up DWM autostart"

    local autostart_dir="$HOME/.dwm"

    if confirm "Set up DWM autostart directory?"; then
        execute "mkdir -p '$autostart_dir'" "Creating autostart directory"

        local autostart_src="$SCRIPT_DIR/dwm/autostart-patch/autostart.sh"
        local autostart_dest="$autostart_dir/autostart.sh"

        if [[ -f "$autostart_src" ]]; then
            create_symlink "$autostart_src" "$autostart_dest" "Linking autostart script"
            execute "chmod +x '$autostart_dest'" "Making autostart executable"
        fi
    fi
}
