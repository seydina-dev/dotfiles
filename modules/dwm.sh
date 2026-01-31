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

    # Setup configuration using the category filter
    if ! create_symlinks_from_config "dwm"; then
        log_error "Failed to setup DWM configuration"
        return 1
    fi

    # Ensure scripts are executable
    local dwmscripts_dest="$HOME/.local/bin/dwmscripts"
    if [[ -d "$dwmscripts_dest" ]] && ! $DRY_RUN; then
        find "$dwmscripts_dest" -type f -exec chmod +x {} \;
    fi

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

    if $DRY_RUN; then
        return 0
    fi

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
