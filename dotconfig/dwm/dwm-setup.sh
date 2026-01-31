#!/bin/sh

source_shared_files() {
    SCRIPTS_DIR="$(cd "$(dirname "../setup.sh")/setup-scripts" && pwd)"
    source "$SCRIPTS_DIR/config.sh" # Source shared variables
    source "$SCRIPTS_DIR/utils.sh" # Source utility functions
    source "$SCRIPTS_DIR/packages.sh" # Source  packages repository
    
    # debugging
    # echo "SCRIPTS_DIR: $SCRIPTS_DIR"
    # echo "DOTFILES_DIR: $DOTFILES_DIR"
    # echo "REPOS_DIR: $REPOS_DIR"
    # echo "packages: ${DWM_REQUIRED_PKGS[@]}"
}

install_required_pkgs() {
    print_status "Installing required packages..."
    for pkg in "${DWM_REQUIRED_PKGS[@]}"; do
        install_pkg "${pkg}"
    done
}

setup_n_install_wm() {
    cd "$REPOS_DIR"
    repo="dwm"
    base_url="https://gitlab.com/sedev077"

    # Clone repository
    [ ! -d "$REPOS_DIR/$repo" ] && git clone "$base_url/$repo.git"

    # Link dwm folder to ~/.config
    cd $repo "$PWD/$repo" "$DOTCONFIG_DIR/$repo"
    print_status "Linking $repo to $DOTCONFIG_DIR/$repo..."
    print_ln_command "$PWD/$repo" "$DOTCONFIG_DIR/$repo"
    ln -sf "$PWD/$repo" "$DOTCONFIG_DIR/$repo"

    # Build and install package
    print_status "Installing $repo..."
    sudo make clean install

    # Return to dotfiles directory
    cd "$DOTFILES_DIR"
}

# dmenu, st(dwm dependencies) 
setup_n_install_deps() {
    cd "$REPOS_DIR"
    base_url="https://gitlab.com/sedev077"
    repos=("dmenu" "st")
    for repo in "${repos[@]}"; do
        # Clone repository
        [ ! -d "$REPOS_DIR/$repo" ] && git clone "$base_url/$repo.git"

        # Link repository folder to ~/.config
        cd $repo
        print_status "Linking $repo to $DOTCONFIG_DIR/$repo..."
        print_ln_command "$PWD/$repo" "$DOTCONFIG_DIR/$repo"
        ln -sf "$PWD/$repo" "$DOTCONFIG_DIR/$repo"

        # Build and install package
        print_status "Installing $repo..."
        sudo make clean install

        # Return to repos directory
        cd ../
    done
    # Return to dotfiles directory
    cd "$DOTFILES_DIR"
}

install_extra_deps() {
    print_status "Installing extra dependencies..."
    for pkg in "${DWM_EXTRA_PKGS[@]}"; do
        install_pkg "${pkg}"
    done
}

install_fonts() {
    read -p "Do you want to install fonts? (y/N): " install_fonts
    if [ "$install_fonts" = "y" ] || [ "$install_fonts" = "Y" ]; then
        print_status "Installing fonts..."
        for font in "${FONT_PKGS[@]}"; do
            install_pkg "${font}"
        done

        # Update font cache
        print_status "Updating font cache..."
        fc-cache -fv
    fi
}

install_nvidia_drivers() {
    read -p "Do you want to install NVIDIA proprietary drivers? (y/N): " install_nvidia
    if [ "$install_nvidia" = "y" ] || [ "$install_nvidia" = "Y" ]; then
        print_status "Installing NVIDIA proprietary drivers..."
        for driver in "${NVIDIA_PROPRITARY_DRIVERS[@]}"; do
            install_pkg "${driver}"
        done
    fi
}

# Link dwmscripts folder to .local/bin
create_dwmscripts_symlink() {
    print_status "Linking dwmscripts folder to $HOME/.local/bin..."

    print_ln_command "$PWD/dwmscripts" "$HOME/.local/bin/dwmscripts"
    ln -sf "$PWD/dwmscripts" "$HOME/.local/bin/dwmscript"
}

# Link .xinitrc and Xresources to home
create_required_symlinks() {
    print_status "Creating required symbolic links..."

    print_ln_command "$PWD/.xinitrc" "$HOME/.xinitrc"
    ln -sf "$PWD/.xinitrc" "$HOME/.xinitrc"

    print_ln_command "$PWD/.Xresources" "$HOME/.Xresources"
    ln -sf "$PWD/.Xresources" "$HOME/.Xresources"
}

# Ask if the user wants to use the autostart.sh script
autostart() {
    read -p "Do you want to use the autostart.sh script? (y/N): " use_autostart
    if [ "$use_autostart" = "y" ] || [ "$use_autostart" = "Y" ]; then
        print_ln_command "$PWD/.dwm" "$HOME/.dwm"
        ln -s "$PWD/.dwm" "$HOME/.dwm"
    fi
}

# Propose to launch dwm
launch_dwm() {
    read -p "Do you want to launch dwm now? (y/N): " launch_dwm
    if [ "$launch_dwm" = "y" ] || [ "$launch_dwm" = "Y" ]; then
        startx
    fi
}

main() {
    print_status "Setting up dwm..."
    source_shared_files
    install_required_pkgs
    setup_n_install_wm
    # setup_n_install_deps
    # install_extra_deps
    # install_fonts
    install_nvidia_drivers
    # create_dwmscripts_symlink
    # create_required_symlinks
    autostart
    # TODO: add a nice ascii art display here
    print_status "Setup complete!"
    launch_dwm
}

# debugging
# source_shared_files

# Execute main
main
