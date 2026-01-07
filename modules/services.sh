#!/usr/bin/env bash

# System services module

module_services() {
    log_step "Managing system services"

    if ! command -v systemctl >/dev/null; then
        log_warning "systemd not available, skipping services"
        return 0
    fi

    local services=()
    mapfile -t services < <(load_package_list "$OS" "services")

    for service in "${services[@]}"; do
        if [[ -n "$service" ]] && [[ ! "$service" =~ ^# ]]; then
            enable_service "$service"
        fi
    done

    return 0
}

enable_service() {
    local service="$1"

    log_substep "Enabling service: $service"

    if ! service_exists "$service"; then
        log_warning "Service not found: $service"
        return 1
    fi

    if service_enabled "$service"; then
        log_debug "Service already enabled: $service"
        return 0
    fi

    execute "sudo systemctl enable '$service'" "Enabling service: $service"
    execute "sudo systemctl start '$service'" "Starting service: $service"

    if service_enabled "$service"; then
        log_success "Enabled and started: $service"
        return 0
    else
        log_error "Failed to enable: $service"
        return 1
    fi
}

service_exists() {
    local service="$1"
    systemctl list-unit-files "$service.service" >/dev/null 2>&1
}

service_enabled() {
    local service="$1"
    systemctl is-enabled "$service.service" >/dev/null 2>&1
}

service_running() {
    local service="$1"
    systemctl is-active "$service.service" >/dev/null 2>&1
}

restart_services() {
    log_step "Restarting services"

    local services=("NetworkManager" "bluetooth")

    for service in "${services[@]}"; do
        if service_exists "$service" && service_running "$service"; then
            execute "sudo systemctl restart '$service'" "Restarting: $service"
        fi
    done
}
