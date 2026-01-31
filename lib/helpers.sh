#!/usr/bin/env bash

# Helper functions for the setup system


install_aur_helper() {
    if command -v yay >/dev/null || command -v paru >/dev/null; then
        log_success "AUR helper already installed"
        return 0
    fi

    log_step "Installing AUR helper"

    local aur_helper="paru"
    local repo="${aur_helper}-bin"
    local repo_url="https://aur.archlinux.org/${repo}.git"
    local clone_dir="$HOME/.local/src/$repo"

    execute "mkdir -p '$HOME/.local/src'" "Creating source directory"
    execute "git clone '$repo_url' '$clone_dir'" "Cloning $repo"
    execute "cd '$clone_dir' && makepkg -si --noconfirm" "Building $aur_helper"

    if command -v "$aur_helper" >/dev/null; then
        log_success "Installed AUR helper: $aur_helper"
        return 0
    else
        log_error "Failed to install AUR helper"
        return 1
    fi
}

install_package() {
    local pkg="$1"

    if package_installed "$pkg"; then
        log_debug "Already installed: $pkg"
        return 0
    fi

    local package_manager
    package_manager=$(detect_package_manager)

    case $package_manager in
        pacman)
            if command -v paru >/dev/null; then
                execute "paru -S --noconfirm '$pkg'" "Installing (AUR): $pkg"
            elif command -v yay >/dev/null; then
                execute "yay -S --noconfirm '$pkg'" "Installing (AUR): $pkg"
            else
                execute "sudo pacman -S --noconfirm '$pkg'" "Installing: $pkg"
            fi
            ;;
        apt)
            execute "sudo apt install -y '$pkg'" "Installing: $pkg"
            ;;
        dnf)
            execute "sudo dnf install -y '$pkg'" "Installing: $pkg"
            ;;
        pkg)
            execute "pkg install -y '$pkg'" "Installing: $pkg"
            ;;
    esac

    if $DRY_RUN; then
        return 0
    fi

    if package_installed "$pkg"; then
        INSTALLED_PACKAGES["$pkg"]=1
        log_success "Installed: $pkg"
        return 0
    else
        log_error "Failed to install: $pkg"
        return 1
    fi
}

package_installed() {
    local pkg="$1"
    local package_manager
    package_manager=$(detect_package_manager)

    case $package_manager in
        pacman)
            pacman -Qi "$pkg" >/dev/null 2>&1
            ;;
        apt)
            dpkg -l "$pkg" 2>/dev/null | grep -q '^ii'
            ;;
        dnf)
            rpm -q "$pkg" >/dev/null 2>&1
            ;;
        pkg)
            pkg list-installed "$pkg" >/dev/null 2>&1
            ;;
        *)
            return 1
            ;;
    esac
}

# Confirmation prompt
confirm() {
    local prompt="${1:-Continue?}"
    local default="${2:-false}"

    if $FORCE; then
        return 0
    fi

    if $DRY_RUN; then
        return 0
    fi

    if [[ $default == true ]]; then
        prompt="$prompt [Y/n] "
    else
        prompt="$prompt [y/N] "
    fi

    while true; do
        if ! read -rp "$prompt" answer; then
            echo -e "\n"
            log_warning "Prompt interrupted. Aborting..."
            exit 130
        fi
        
        case "${answer:-$default}" in
            [Yy]*|true) return 0 ;;
            [Nn]*|false) return 1 ;;
            *) echo "Please answer yes or no." ;;
        esac
    done
}

# Detect operating system
detect_os() {
    if [[ -f /etc/arch-release ]]; then
        OS="arch"
    elif [[ -f /etc/fedora-release ]]; then
        OS="fedora"
    elif [[ -f /etc/debian_version ]]; then
        OS="debian"
    elif grep -q "Ubuntu" /etc/os-release 2>/dev/null; then
        OS="ubuntu"
    elif [[ -d /data/data/com.termux ]]; then
        OS="termux"
    else
        OS="unknown"
    fi

    log_debug "Detected OS: $OS"
    echo "$OS"
}

# Detect package manager
detect_package_manager() {
    case $OS in
        arch) echo "pacman" ;;
        debian|ubuntu) echo "apt" ;;
        fedora) echo "dnf" ;;
        termux) echo "pkg" ;;
        *) echo "unknown" ;;
    esac
}

# Execute command with dry-run support
execute() {
    local command="$1"
    local description="${2:-Running: $command}"

    log_substep "$description"

    if $DRY_RUN; then
        log_debug "[DRY RUN] $command"
        return 0
    fi

    if $VERBOSE; then
        log_debug "Executing: $command"
    fi

    # Use eval for complex commands with pipes/redirects
    local exit_code=0
    eval "$command" || exit_code=$?

    if [[ $exit_code -eq 130 ]]; then
        exit 130
    fi

    return $exit_code
}

# Backup file if it exists
backup_file() {
    local file="$1"

    if [[ ! -e "$file" ]]; then
        return 0
    fi

    local backup_path="$BACKUP_DIR/$(basename "$file")"

    log_substep "Backing up: $file → $backup_path"

    if $DRY_RUN; then
        return 0
    fi

    mkdir -p "$(dirname "$backup_path")"
    cp -r "$file" "$backup_path" 2>/dev/null || true
}

# Create symbolic link with backup
create_symlink() {
    local source="$1"
    local target="$2"
    local description="${3:-Linking $source → $target}"

    if [[ ! -e "$source" ]]; then
        log_error "Source not found: $source"
        return 1
    fi

    log_substep "$description"

    # Backup existing target
    if [[ -e "$target" ]] || [[ -L "$target" ]]; then
        backup_file "$target"

        if ! $DRY_RUN; then
            rm -rf "$target"
        fi
    fi

    # Create parent directories
    local target_dir=$(dirname "$target")
    if [[ ! -d "$target_dir" ]]; then
        execute "mkdir -p '$target_dir'" "Creating directory: $target_dir"
    fi

    # Create symlink
    execute "ln -sf '$source' '$target'" "Creating symlink: $source → $target"
}


# Create symbolic links from a configuration file
# Supports filtering by category
create_symlinks_from_config() {
    local filter_category="${1:-global}"
    local symlinks_file="$CONFIG_DIR/symlinks.conf"

    if [[ ! -f "$symlinks_file" ]]; then
        log_error "Symlinks config not found: $symlinks_file"
        return 1
    fi

    log_step "Creating symbolic links (Category: $filter_category)"

    local count=0
    while IFS=: read -r source target description category; do
        # Skip comments and empty lines
        [[ "$source" =~ ^#.* ]] || [[ -z "$source" ]] && continue

        # Apply category filter
        category="${category:-global}"
        if [[ "$category" != "$filter_category" ]]; then
            continue
        fi

        # Resolve source path relative to script directory
        local full_source="$SCRIPT_DIR/$source"
        local full_target="$target"

        # Expand ~ in target path
        full_target="${full_target/#\~/$HOME}"

        if [[ -z "$description" ]]; then
            description="Linking $source → $target"
        fi

        if create_symlink "$full_source" "$full_target" "$description"; then
            ((count++))
        else
            log_warning "Failed to create symlink: $source → $target"
        fi
    done < "$symlinks_file"

    log_success "Created $count symbolic links for category: $filter_category"
    return 0
}

# Load package list based on current OS
# Format in file: [category]
# arch:fedora:debian:termux
load_package_list() {
    local category="$1"
    local config_file="$CONFIG_DIR/packages.conf"
    local os_index=1

    case "$OS" in
        arch)   os_index=1 ;;
        fedora) os_index=2 ;;
        debian|ubuntu) os_index=3 ;;
        termux) os_index=4 ;;
    esac

    if [[ ! -f "$config_file" ]]; then
        log_error "Package config not found: $config_file"
        return 1
    fi

    awk -v cat="[$category]" -v idx="$os_index" '
        $0 == cat { found=1; next }
        /^\[/ && found { found=0 }
        found && NF && !/^#/ {
            split($0, pkgs, ":")
            if (pkgs[idx] != "") print pkgs[idx]
        }
    ' "$config_file"
}
