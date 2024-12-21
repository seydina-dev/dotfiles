#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
    echo -e "${GREEN}[*]${NC} $1"
}

# Function to print error messages
print_error() {
    echo -e "${RED}[!]${NC} $1"
}

# Function to backup existing dotfiles
backup_dotfiles() {
    print_status "Creating backup of existing dotfiles..."
    backup_dir="$HOME/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Add files to backup here
    [ -f "$HOME/.bashrc" ] && mv "$HOME/.bashrc" "$backup_dir/"
    [ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$backup_dir/"
}

# Function to create symbolic links
create_symlinks() {
    print_status "Creating symbolic links..."
    
    # Add your dotfiles here
    ln -sf "$PWD/.bashrc" "$HOME/.bashrc"
    ln -sf "$PWD/.zshrc" "$HOME/.zshrc"
    ln -sf "$PWD/aliasrc" "$HOME/.aliasrc"
    ln -sf "$PWD/functionrc" "$HOME/.functionrc"
    ln -sf "$PWD/path_variablerc" "$HOME/.path_variablerc"
}

# Function to install required packages
install_packages() {
    print_status "Installing required packages..."
    # Add your required packages here
    packages="git vim curl"
    
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y $packages
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Syu --noconfirm $packages
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y $packages
    else
        print_error "Package manager not supported"
        exit 1
    fi
}


# Function to enable essential services
enable_services() {
    print_status "Enabling essential services..."
    if command -v systemctl >/dev/null 2>&1; then
        services="NetworkManager bluetooth sddm sshd"
        for service in $services; do
            if systemctl is-enabled "$service" >/dev/null 2>&1; then
                print_status "$service is already enabled"
            else
                sudo systemctl enable "$service"
                print_status "Enabled $service"
            fi
        done
    else
        print_error "systemd not found, skipping service enablement"
    fi
}

# Main setup function
main() {
    print_status "Starting dotfiles setup..."
    backup_dotfiles
    install_packages
    create_symlinks
    enable_services
    print_status "Setup completed successfully!"
    print_status "Please restart your shell or run: source ~/.bashrc"
}

# Run main function
main