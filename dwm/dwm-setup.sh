#!/bin/sh

#!/bin/bash

# Source shared files
SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/config.sh" # Source shared variables
source "$SCRIPT_DIR/utils.sh" # Source utility functions

# Check if script is run with sudo
check_sudo() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run with sudo privileges"
        print_status "Please run: sudo $0"
        exit 1
    fi
}

# Cache sudo credentials
cache_sudo() {
    sudo -v
    # Keep sudo credentials fresh
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
}

# Function to handle sudo commands
run_sudo_command() {
    if ! sudo "$@"; then
        print_error "Failed to execute: sudo $*"
        exit 1
    fi
}

# Requirements: base-devel -> build PKGBUILD for dwm, st, and dmenu
install_required_package() {
    print_status "Installing required packages..."
    pkg="base-devel"

    run_sudo_command pacman -Syu --noconfirm --needed $pkg
}


# TODO: 1. setup_n_install_wm() -> dwm
#       2. setup_n_install_deps() -> dmenu, st(dwm dependencies) 
#       3. install_extra_deps() -> xorg, xorg-xrandr, picom, nitrogen, pywal, feh.
install_wm() {
    cd "$REPOS_DIR"
    base_url="https://gitlab.com/sedev077"
    repos=("dwm" "dmenu" "st")
    for repo in "${repos[@]}"; do
        # Clone repositoriesS
        [ ! -d "$REPOS_DIR/$repo" ] && git clone "$base_url/$repo.git"

        # Link dwm folder to ~/.config
        cd $repo
        print_status "Linking $repo to $DOTCONFIG_DIR/$repo..."
        ln -sf "$PWD/$repo" "$DOTCONFIG_DIR/$repo"

        # Build and install package
        print_status "Installing $repo..."
        run_sudo_command make clean install
        # Return to repos directory
        cd ../
    done
    # Return to dotfiles directory
    cd "$DOTFILES_DIR"
}

# Link dwmscripts folder to .local/bin
create_dwmscripts_symlink() {
    print_status "Linking dwmscripts folder to $HOME/.local/bin..."
    ln -sf "$PWD/dwmscripts" "$HOME/.local/bin/dwmscript"
}


# Link .xinitrc and Xresources to home
create_required_symlinks() {
    print_status "Creating required symbolic links..."

    ln -sf "$PWD/.xinitrc" "$HOME/.xinitrc"
    ln -sf "$PWD/Xresources" "$HOME/.Xresources"
}

# Ask if the user wants to use the autostart.sh script
autostart() {
    read -p "Do you want to use the autostart.sh script? (y/n): " use_autostart
    if [ "$use_autostart" =~ ^[Yy]$ ]; then
        ln -s "$PWD/.dwm" "$HOME/.dwm"
    fi
}

# Propose to launch dwm
launch_dwm() {
    read -p "Do you want to launch dwm now? (y/n): " launch_dwm
    if [ "$launch_dwm" =~ ^[Yy]$ ]; then
        startx
    fi
}

main() {
    init_variables # Initialize variables from base-setup.sh
    check_sudo
    cache_sudo
    install_required_package
    install_wm
    create_required_symlinks
    create_dwmscripts_symlink
    autostart
    launch_dwm
}

# Execute main
main
