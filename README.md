# Dotfiles

Personal Linux environment configuration with automated setup for window managers and development tools.

## Prerequisites

- Git
- Base development tools (`base-devel` on Arch, `build-essential` on Debian/Ubuntu)
- Sudo privileges

## Structure Overview

The setup is organized into modular components:

```
├── custom-scripts/    # Professional toolkit (installed to ~/.local/bin)
├── dotconfig/         # Application configs (target: ~/.config)
│   ├── dwm/           # DWM specific setup
│   ├── gtk-3.0/       # GTK3 settings
│   ├── helix/         # helix editor
│   ├── hypr/          # Hyprland setup
│   ├── kitty/         # Terminal emulator
│   ├── picom/         # Compositor
│   ├── qt5ct/         # Qt5 settings
│   ├── sxhkd/         # Hotkey daemon
│   └── sxiv/          # Simple X Image Viewer
├── home/              # User-level dotfiles (~/.bashrc, etc.)
├── setup/             # Setup configuration
│   ├── packages.conf  # Unified package list
│   └── symlinks.conf  # Symlink definitions
├── lib/               # Shared helper libraries
├── modules/           # Modular installation scripts
├── README.md          # This file
└── setup.sh           # Main setup script

```

## Quick Start

1. Clone the repository:

```bash
git clone https://github.com/seydina-dev/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

2. Basic system setup:

````bash
./setup.sh

3. (Optional) Install window manager modules:

```bash
./setup.sh -m hyprland    # Install Hyprland
./setup.sh -m dwm         # Install DWM
```

## What Gets Installed

### System Modules (`setup.sh`)

- **`base`**: Essential packages (git, vim, curl, etc.)
- **`dotfiles`**: Global shell configurations (Bash, Zsh, Vim)
- **`fonts`**: JetBrains Mono, Font Awesome, and other nerd fonts.
- **`scripts`**: Links the professional toolkit in `custom-scripts/`.
- **`services`**: System services (NetworkManager, Bluetooth, SSH).
- **`hyprland`**: Full Hyprland setup including configs and dependencies.
- **`dwm`**: DWM window manager setup (builds from source).


## Configuration Options

### Manual Customization

1. Edit `setup/packages.conf` to modify:

   - Package selections
   - Cross-distro names


2. Environment variables in `home/path_variablerc`:

   - Custom PATH additions
   - Development tool configs

3. Shell customization:
   - Aliases: Edit `home/aliasrc`
   - Functions: Modify `home/functionrc`

### Window Manager Setup

The DWM setup is modular and includes:

- Custom keybindings
- Status bar scripts
- Autostart capabilities

## Custom Scripts Documentation

The repository includes a professional toolkit of scripts located in `custom-scripts/`, which are automatically symlinked to `~/.local/bin/`.

### System & Universal Helpers
- **`sys-menu`**: Universal selector that automatically picks between Wofi (Wayland), Dmenu (X11), or fzf (Terminal).
- **`sys-clip`**: Cross-platform clipboard manager (Wayland, X11, Termux, macOS).
- **`sys-mount-disk` / `sys-unmount-disk`**: Interactive partition mounter using `udisksctl`.
- **`sys-mount-phone` / `sys-unmount-phone`**: Interactive Android device mounter via `simple-mtpfs`.
- **`smci`**: Helper for `sudo make clean install` (cleans up `config.h` if `config.def.h` exists).
- **`dad`**: Daemon manager for `aria2c` RPC.

### Media & Streaming
- **`ani`**: Interactive Anime downloader and player (via `ani-cli`).
- **`senflix`**: Search and stream French series using `oxtorrent`.
- **`notflix`**: Search and stream movies using `1337x`.
- **`play`**: Interactive media player with dynamic path detection.
- **`record`**: Screen recorder using `ffmpeg` (X11).
- **`ffcompress`**: Quick video compression using `ffmpeg`.

### File & Directory Management
- **`elbin`**: Interactive script editor for your custom toolkit.
- **`rmd`**: Interactive directory removal with `fzf` multi-select.
- **`vimv`**: Bulk rename files using your preferred editor.
- **`findd`**: Search for a directory and change to it instantly.
- **`move`**: Utility to move recovered files to categorized directories.

### Window Manager Utilities
- **`setwal`**: Set wallpaper and generate system-wide colors using `pywal`.
- **`setbg`**: Quick wallpaper setter.
- **`leb`**: Interactive configuration editor for window managers and app configs.
- **`screenManager`**: Quick display configuration tool.
- **`rmcl`**: Fixes `pywal` color formatting for DWM.

## Troubleshooting


### Common Issues

1. Permission errors:

```bash
sudo chown -R $USER:$USER ~/.dotfiles
```

2. Missing dependencies:

```bash
# Arch Linux
sudo pacman -Syu base-devel git
# Ubuntu/Debian
sudo apt update && sudo apt install build-essential git
```

3. Broken symlinks:

```bash
./setup.sh --repair
```

## Maintenance

### Updating

```bash
cd ~/.dotfiles
git pull
./setup.sh --update
```

### Backing Up

The setup automatically creates backups before making changes:

- Location: `~/.dotfiles.backup.YYYYMMDD_HHMMSS`
- Includes all replaced configurations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a Pull Request

## License

MIT
