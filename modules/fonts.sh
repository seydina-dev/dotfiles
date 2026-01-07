#!/usr/bin/env bash

# Fonts installation module

module_fonts() {
    log_step "Installing fonts"

    if ! confirm "Install fonts?"; then
        log_info "Skipping font installation"
        return 0
    fi

    local fonts=()
    mapfile -t fonts < <(load_package_list "$OS" "fonts")

    local installed_count=0
    for font in "${fonts[@]}"; do
        if [[ -n "$font" ]] && [[ ! "$font" =~ ^# ]]; then
            if install_package "$font"; then
                ((installed_count++))
            fi
        fi
    done

    # Update font cache
    execute "fc-cache -fv" "Updating font cache"

    log_success "Installed $installed_count fonts"
    return 0
}

install_nerd_fonts() {
    log_step "Installing Nerd Fonts"

    local nerd_fonts=(
        "ttf-jetbrains-mono-nerd"
        "ttf-meslo-nerd"
        "ttf-firacode-nerd"
    )

    for font in "${nerd_fonts[@]}"; do
        install_package "$font"
    done
}

install_custom_fonts() {
    log_step "Installing custom fonts"

    local fonts_dir="$HOME/.local/share/fonts"
    local custom_fonts_dir="$SCRIPT_DIR/fonts"

    if [[ ! -d "$custom_fonts_dir" ]]; then
        log_debug "No custom fonts directory found"
        return 0
    fi

    execute "mkdir -p '$fonts_dir'" "Creating fonts directory"

    # Copy custom fonts
    if [[ -d "$custom_fonts_dir" ]]; then
        execute "cp -r '$custom_fonts_dir'/* '$fonts_dir'/'" "Copying custom fonts"
        execute "fc-cache -fv" "Updating font cache"
        log_success "Installed custom fonts"
    fi
}
