# Dotfiles

Personal Linux environment configuration with automated setup for window managers and development tools.

## Prerequisites

- Git
- Base development tools (`base-devel` on Arch, `build-essential` on Debian/Ubuntu)
- Sudo privileges

## Structure

```
├── .config/           # Application configs
│   ├── gtk-3.0/       # GTK3 settings
│   ├── kitty/         # Terminal emulator
│   ├── picom/         # Compositor
│   ├── qt5ct/         # Qt5 settings
│   ├── sxhkd/         # Hotkey daemon
│   └── sxiv/          # Simple X Image Viewer
├── base-setup.sh      # Main setup script
├── config.sh          # Shared configuration
├── custom-scripts/    # Custom utility scripts
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
├── README.md
└── utils.sh          # Utility functions
```

## Quick Start

1. Clone the repository:

```bash
git clone https://github.com/seydina-dev/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

2. Basic system setup:

```bash
./base-setup.sh
```

3. (Optional) DWM window manager setup:

```bash
./dwm/dwm-setup.sh
```

## What Gets Installed

### Base Setup (`base-setup.sh`)

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

1. Edit `config.sh` to modify:

   - Installation paths
   - Package selections
   - Default applications

2. Environment variables in `home/path_variablerc`:

   - Custom PATH additions
   - Development tool configs

3. Shell customization:
   - Aliases: Edit files in `home/aliasrc`
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
./base-setup.sh --repair
```

## Maintenance

### Updating

```bash
cd ~/.dotfiles
git pull
./base-setup.sh --update
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
