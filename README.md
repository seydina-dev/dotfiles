# Dotfiles

Personal dotfiles for Linux and Windows environments.

## Structure

```
├── linux/
│ ├── .bashrc # Bash shell configuration
│ ├── .zshrc # Zsh shell configuration
│ ├── aliasrc # Shell aliases
│ ├── functionrc # Shell functions
│ ├── path_variablerc # Path and environment variables
│ └── setup.sh # Installation script
└── windows/
├── profile.ps1 # PowerShell profile
└── terminal-settings.json # Windows Terminal settings
```

## Features

- Shell configuration for both Bash and Zsh
- Useful aliases and functions
- Automatic package installation
- Service management
- Windows Terminal customization
- PowerShell configuration

## Installation

### Linux

```sh
cd linux
./setup.sh
```

The setup script will:

1. Backup existing dotfiles
2. Install required packages
3. Create symbolic links
4. Enable essential services

### Windows

1. Copy `profile.ps1` to your PowerShell profile location
2. Copy `terminal-settings.json` to Windows Terminal settings

## Key Components

### Linux Components

- Shell configurations with aliases and functions
- Path variable management
- Package manager wrappers
- Git shortcuts
- File management utilities

### Windows Components

- PowerShell configuration with aliases
- Windows Terminal settings with:
  - Tokyo Night color scheme
  - JetBrainsMono Nerd Font
  - Custom opacity and background
  - Keyboard shortcuts

## License

MIT
