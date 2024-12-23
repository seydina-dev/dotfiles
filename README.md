# Dotfiles

Personal Linux environment configuration with automated setup for window managers and development tools.

## Prerequisites

- Git
- Base development tools (`base-devel` on Arch, `build-essential` on Debian/Ubuntu)
- Sudo privileges

## Structure Overview

The setup is organized into modular components:

```
├── .config/           # Application configs
│   ├── gtk-3.0/       # GTK3 settings
│   ├── kitty/         # Terminal emulator
│   ├── picom/         # Compositor
│   ├── qt5ct/         # Qt5 settings
│   ├── sxhkd/         # Hotkey daemon
│   └── sxiv/          # Simple X Image Viewer
├── custom-scripts/    # Custom utility scripts
│   ├── ani
│   ├── dad
│   ├── elbin
│   ├── ffcompress
│   ├── findd
│   ├── fzftest
│   ├── leb
│   ├── mdisk
│   ├── mountdisk
│   ├── mountjutsu
│   ├── mountphone
│   ├── move
│   ├── mphone
│   ├── notflix
│   ├── play
│   ├── record
│   ├── rmcl
│   ├── rmd
│   ├── screen
│   ├── screenManager
│   ├── senflix
│   ├── setbg
│   ├── setwal
│   ├── smci
│   ├── udisk
│   ├── umountphone
│   ├── uphone
│   └── vimv
├── dwm/               # DWM window manager setup
│   ├── .xinitrc
│   ├── .Xresources
│   ├── autostart-patch/
│   ├── dwm-setup.sh
│   └── dwmscripts/
├── home/              # Home directory configurations
│   ├── .bashrc
│   ├── .vimrc
│   ├── .zshrc
│   ├── aliasrc
│   ├── functionrc
│   └── path_variablerc
├── setup-scripts/     # Setup scripts
│   ├── config.sh
│   ├── packages.sh    # The packages repository
│   └── utils.sh
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

3. (Optional) DWM window manager setup:

```bash
./dwm/dwm-setup.sh
````

## What Gets Installed

### Base Setup (`setup.sh`)

- Essential packages (git, vim, curl)
- Shell configurations (Bash, Zsh)
- Terminal configuration (Kitty)
- Development tools
- System services (NetworkManager, Bluetooth, SSH)

### DWM Setup (`dwm/dwm-setup.sh`)

- DWM window manager
- ST terminal
- dmenu
- Picom compositor
- Additional X11 utilities

## Configuration Options

### Manual Customization

1. Edit `setup-scripts/config.sh` to modify:

   - Installation paths
   - Package selections
   - Default applications

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
