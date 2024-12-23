# """"""""""""""
# " ./setup.sh "
# """"""""""""""
#!/bin/sh

# Source shared files
source_shared_files() {
    SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/setup-scripts" && pwd)"
    source "$SCRIPTS_DIR/config.sh" # Source shared variables
    source "$SCRIPTS_DIR/utils.sh" # Source utility functions
    source "$SCRIPTS_DIR/packages.sh" # Source packages repository
}

print_source_code(){
    [ ! -z "$(command -v bat)" ] && bat "$SCRIPTS_DIR/config.sh" >./base-setup.sh || less "$SCRIPTS_DIR/config.sh" >base-setup.sh
    [ ! -z "$(command -v bat)" ] && bat "$SCRIPTS_DIR/utils.sh" >>./base-setup.sh || less "$SCRIPTS_DIR/utils.sh" >>base-setup.sh
    [ ! -z "$(command -v bat)" ] && bat "$0" >>./base-setup.sh || less "$0" >>base-setup.sh
    [ ! -z "$(command -v bat)" ] && bat "./base-setup.sh" || less "./base-setup.sh"
    rm -rf ./base-setup.sh

    read -p "Press enter to continue"
}

# Function to backup existing dotfiles
backup_dotfiles() {
    print_status "Creating backup of existing dotfiles..."
    backup_dir="$HOME/.dotfiles.backup.$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    [ -f "$HOME/.bashrc" ] && mv "$HOME/.bashrc" "$backup_dir/"
    [ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$backup_dir/"
    [ -f "$HOME/.vimrc" ] && mv "$HOME/.vimrc" "$backup_dir/"
    [ -f "$HOME/.aliasrc" ] && mv "$HOME/.aliasrc" "$backup_dir/"
    [ -f "$HOME/.functionrc" ] && mv "$HOME/.functionrc" "$backup_dir/"
    [ -f "$HOME/.path_variablerc" ] && mv "$HOME/.path_variablerc" "$backup_dir/"
}


# Function to create symbolic links
create_home_symlinks() {
    print_status "Linking the Home dotfiles..."
    
    print_ln_command "$HOME_DOTFILES_SRC_DIR/.zshrc" "$HOME_DOTFILES_DEST_DIR/.zshrc"
    ln -sf "$HOME_DOTFILES_SRC_DIR/.zshrc" "$HOME_DOTFILES_DEST_DIR/.zshrc"

    print_ln_command "$HOME_DOTFILES_SRC_DIR/.vimrc" "$HOME_DOTFILES_DEST_DIR/.vimrc"
    ln -sf "$HOME_DOTFILES_SRC_DIR/.vimrc" "$HOME_DOTFILES_DEST_DIR/.vimrc"

    print_ln_command "$HOME_DOTFILES_SRC_DIR/.bashrc" "$HOME_DOTFILES_DEST_DIR/.bashrc"
    ln -sf "$HOME_DOTFILES_SRC_DIR/.bashrc" "$HOME_DOTFILES_DEST_DIR/.bashrc"

    print_ln_command "$HOME_DOTFILES_SRC_DIR/aliasrc" "$HOME_DOTFILES_DEST_DIR/.aliasrc"
    ln -sf "$HOME_DOTFILES_SRC_DIR/aliasrc" "$HOME_DOTFILES_DEST_DIR/.aliasrc"
    
    print_ln_command "$HOME_DOTFILES_SRC_DIR/functionrc" "$HOME_DOTFILES_DEST_DIR/.functionrc"
    ln -sf "$HOME_DOTFILES_SRC_DIR/functionrc" "$HOME_DOTFILES_DEST_DIR/.functionrc"
    
    print_ln_command "$HOME_DOTFILES_SRC_DIR/path_variablerc" "$HOME_DOTFILES_DEST_DIR/.path_variablerc"
    ln -sf "$HOME_DOTFILES_SRC_DIR/path_variablerc" "$HOME_DOTFILES_DEST_DIR/.path_variablerc"
}

create_local_bin_symlink() {
    for script in "$PWD/custom-scripts"/*; do
        print_ln_command "$script" "$DOTLOCAL_BIN_DIR/$(basename "$script")"
        ln -sf "$script" "$DOTLOCAL_BIN_DIR/$(basename "$script")"
    done
}

# Function to install base packages
install_base_pkgs() {
    print_status "Installing base packages..."
    for pkg in "${BASE_PKGS[@]}"; do
        install_pkg "${pkg}"
    done
}

# Function to enable essential services
enable_services() {
    print_status "Enabling essential services..."
    if command -v systemctl >/dev/null; then
        for service in "${SERVICES[@]}"; do
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

setup_dotconfig() {
    print_status "Linking the .config directories..."

    print_ln_command "$DOTCONFIG_SRC_DIR/kitty" "$DOTCONFIG_DEST_DIR/kitty"
    ln -sf "$DOTCONFIG_SRC_DIR/kitty" "$DOTCONFIG_DEST_DIR/kitty"

    print_ln_command "$DOTCONFIG_SRC_DIR/gtk-3.0" "$DOTCONFIG_DEST_DIR/gtk-3.0"
    ln -sf "$DOTCONFIG_SRC_DIR/gtk-3.0" "$DOTCONFIG_DEST_DIR/gtk-3.0"
    
    print_ln_command "$DOTCONFIG_SRC_DIR/picom" "$DOTCONFIG_DEST_DIR/picom"
    ln -sf "$DOTCONFIG_SRC_DIR/picom" "$DOTCONFIG_DEST_DIR/picom"

    print_ln_command "$DOTCONFIG_SRC_DIR/qt5ct" "$DOTCONFIG_DEST_DIR/qt5ct"
    ln -sf "$DOTCONFIG_SRC_DIR/qt5ct" "$DOTCONFIG_DEST_DIR/qt5ct"

    print_ln_command "$DOTCONFIG_SRC_DIR/sxhkd" "$DOTCONFIG_DEST_DIR/sxhkd"
    ln -sf "$DOTCONFIG_SRC_DIR/sxhkd" "$DOTCONFIG_DEST_DIR/sxhkd"
    
    print_ln_command "$DOTCONFIG_SRC_DIR/sxiv" "$DOTCONFIG_DEST_DIR/sxiv"
    ln -sf "$DOTCONFIG_SRC_DIR/sxiv" "$DOTCONFIG_DEST_DIR/sxiv"
}

install_dwm() {
    printf "Do you want to install dwm? [y/N]: " && read choice
    if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        print_status "Installing dwm..."
        cd dwm || { print_error "Failed to enter dwm directory" ; exit 1; }
        chmod +x ./dwm-setup.sh && ./dwm-setup.sh
    fi
}

# Main setup function
main() {
    source_shared_files
    print_source_code
    print_status "Starting dotfiles setup..."
    backup_dotfiles
    install_aur_helper
    install_base_pkgs
    enable_services
    setup_dotconfig
    create_home_symlinks
    create_local_bin_symlink
    print_status "Base Setup completed successfully!"
    install_dwm
    print_status "Please restart your shell or run: source ~/.bashrc"
}

# Debugging
# source_shared_files

# Run main function
main
