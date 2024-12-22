#!/bin/sh

# Source shared files
SCRIPTS_DIR="$(cd "$(dirname "$0/setup-script")" && pwd)"
source "$SCRIPT_DIR/config.sh" # Source shared variables
source "$SCRIPT_DIR/utils.sh" # Source utility functions

# Function to backup existing dotfiles
backup_dotfiles() {
    print_status "Creating backup of existing dotfiles..."
    backup_dir="$HOME/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    [ -f "$HOME/.bashrc" ] && mv "$HOME/.bashrc" "$backup_dir/"
    [ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$backup_dir/"
}

# Function to create symbolic links
create_home_symlinks() {
    print_status "Creating symbolic links..."
    
    ln -sf "$HOME_DOTFILES_SRC_DIR/.zshrc" "$HOME_DOTFILES_DEST_DIR/.zshrc"
    ln -sf "$HOME_DOTFILES_SRC_DIR/.vimrc" "$HOME_DOTFILES_DEST_DIR/.vimrc"
    ln -sf "$HOME_DOTFILES_SRC_DIR/.bashrc" "$HOME_DOTFILES_DEST_DIR/.bashrc"
    ln -sf "$HOME_DOTFILES_SRC_DIR/aliasrc" "$HOME_DOTFILES_DEST_DIR/.aliasrc"
    ln -sf "$HOME_DOTFILES_SRC_DIR/functionrc" "$HOME_DOTFILES_DEST_DIR/.functionrc"
    ln -sf "$HOME_DOTFILES_SRC_DIR/path_variablerc" "$HOME_DOTFILES_DEST_DIR/.path_variablerc"
}

create_local_bin_symlink() {
    print_status "Linking bin folder to ~/.local/bin..."
    ln -sf "$PWD/bin" "$DOTLOCAL_DIR/bin"
}

# Function to install essential packages
install_packages() {
    print_status "Installing essential packages..."
    # Add your required packages here
    packages="fzf ffmpeg ranger openssh networkmanager htop vim curl zsh kitty pfetch nvim zellij dhcpcd"
    
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y $packages
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Syu --noconfirm --needed $packages
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
        services="NetworkManager bluetooth sddm sshd dhcpcd"
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

setup-dotconfig() {
    print_status "Setting up .config directory..."
    ln -sf "$DOTCONFIG_SRC_DIR/kitty" "$DOTCONFIG_DEST_DIR/kitty"
    ln -sf "$DOTCONFIG_SRC_DIR/gtk-3.0" "$DOTCONFIG_DEST_DIR/gtk-3.0"
    ln -sf "$DOTCONFIG_SRC_DIR/picom" "$DOTCONFIG_DEST_DIR/picom"
    ln -sf "$DOTCONFIG_SRC_DIR/qt5ct" "$DOTCONFIG_DEST_DIR/qt5ct"
    ln -sf "$DOTCONFIG_SRC_DIR/sxhkd" "$DOTCONFIG_DEST_DIR/sxhkd"
    ln -sf "$DOTCONFIG_SRC_DIR/sxiv" "$DOTCONFIG_DEST_DIR/sxiv"
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