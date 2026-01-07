#!/usr/bin/env bash

# Validation functions

validate_directory() {
    local dir="$1"
    local description="${2:-Directory}"

    if [[ ! -d "$dir" ]]; then
        log_error "$description does not exist: $dir"
        return 1
    fi

    if [[ ! -r "$dir" ]]; then
        log_error "$description is not readable: $dir"
        return 1
    fi

    return 0
}

validate_file() {
    local file="$1"
    local description="${2:-File}"

    if [[ ! -f "$file" ]]; then
        log_error "$description does not exist: $file"
        return 1
    fi

    if [[ ! -r "$file" ]]; then
        log_error "$description is not readable: $file"
        return 1
    fi

    return 0
}

validate_executable() {
    local cmd="$1"
    local description="${2:-Command}"

    if ! command -v "$cmd" >/dev/null; then
        log_error "$description not found: $cmd"
        return 1
    fi

    return 0
}

check_disk_space() {
    local required_mb="${1:-100}"
    local available_mb

    available_mb=$(df / | awk 'NR==2 {print $4}')
    available_mb=$((available_mb / 1024))

    if [[ $available_mb -lt $required_mb ]]; then
        log_error "Insufficient disk space. Available: ${available_mb}MB, Required: ${required_mb}MB"
        return 1
    fi

    log_debug "Disk space available: ${available_mb}MB"
    return 0
}

validate_symlink() {
    local target="$1"
    local link="$2"

    if [[ -L "$link" ]]; then
        local current_target
        current_target=$(readlink "$link")

        if [[ "$current_target" != "$target" ]]; then
            log_warning "Symlink points to different target: $link → $current_target (expected: $target)"
            return 1
        fi
    fi

    return 0
}
