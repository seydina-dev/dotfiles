#!/usr/bin/env bash

module_wifi() {
    log_step "Installing external WiFi drivers"

    local packages=()
    if ! load_package_list "wifi" > /dev/null; then
        log_error "Failed to load wifi package list"
        return 1
    fi

    mapfile -t packages < <(load_package_list "wifi")

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

    log_success "Installed $installed_count of $total_count wifi drivers"
    return 0
}
