# 🎨 Antigravity Theme System

This system provides a seamless way to switch between Dark and Light modes across all components.

## 🚀 How to Toggle
Press `SUPER + SHIFT + T` to switch modes.

## 📁 Managed Components

| Component | Logic | Config Path |
| :--- | :--- | :--- |
| **Waybar** | Symlinks style | `~/.config/waybar/styles/` |
| **Wofi** | Symlinks style | `~/.config/wofi/styles/` |
| **Mako** | Symlinks config | `~/.config/mako/styles/` |
| **Kitty** | Symlinks theme | `~/.config/kitty/themes/` |
| **Helix** | Edits config.toml | `~/.config/helix/config.toml` |
| **GTK/Icons** | gsettings | - |

## 🛠 Adding New Components
To add a new application to the toggle:
1. Create both dark and light versions of its configuration.
2. Update `~/.config/hypr/scripts/DarkLight.sh` to include the logic (usually a `ln -sf` or `sed`).
3. Add a reload command if the application doesn't pick up changes automatically.

## ⌨️ Help System
Press `SUPER + H` to generate and view a dynamic list of keybindings. This list is generated on-the-fly from `keybinds.lua`.
To improve descriptions, add a `-- Comment` at the end of your bind lines in `keybinds.lua`.
