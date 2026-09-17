# 🌌 Antigravity Arch-Hyprland Master Guide

Welcome to your new system! This guide explains how everything is connected so you can customize it without getting lost.

## ⌨️ Keybindings & The Help System (`SUPER + H`)
Your keybindings are managed in `~/.config/hypr/configs/keybinds.lua`.

### How it works:
When you press `SUPER + H`, a Python script (`GenerateHelp.py`) reads your `keybinds.lua` file, finds every line starting with `hl.bind`, and builds a table.
*   **To add a description:** Just add a comment at the end of the line:
    `hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser)) -- Open Chrome`
*   **The Pager:** It uses `bat` (a better `cat`) to show the menu. Use the arrow keys to scroll and `q` to quit.

---

## 🎨 The Theme System (`SUPER + SHIFT + T`)
Your system has a "Dynamic Symlink" theme engine located at `~/.config/hypr/scripts/DarkLight.sh`.

### What happens when you toggle:
1.  **State Check:** It looks at `~/.wallpaper_mode` to see if you are currently in "light" or "dark".
2.  **Symlinking:** It swaps the "active" config files for several apps:
    *   **Waybar:** Links `style.css` to either `styles/style-dark.css` or `style-light.css`.
    *   **Wofi:** Links its `style.css` similarly.
    *   **Mako:** Links its `config` to a dark or light version.
    *   **Kitty:** Swaps `current-theme.conf`.
3.  **GTK Injection:** It uses `gsettings` to tell your Apps (like Thunar) to switch to Catppuccin-Mocha or Catppuccin-Latte.
4.  **Live Reload:** It kills and restarts Waybar/Mako and sends a signal to Kitty to refresh instantly without closing your windows.

---

## 🔍 Wofi Launcher (`SUPER + D` and `SUPER + SHIFT + D`)
Wofi is your application launcher.
*   **Config:** Located in `~/.config/wofi/config`.
*   **Big Mode:** `SUPER + SHIFT + D` launches a larger version (`WofiBig`) for when you want a clearer view.
*   **Styling:** Both versions share the same `style.css`, which is automatically updated by the theme toggle.

---

## 📂 Important Directories
| Path | Purpose |
| :--- | :--- |
| `~/.config/hypr/configs/` | The "Brain" (Keybinds, Rules, Execs). |
| `~/.config/hypr/scripts/` | The "Engine" (Theme toggle, Help, Volume). |
| `~/.config/waybar/styles/` | Where your Bar's dark/light looks live. |
| `~/.config/kitty/themes/` | Where your Terminal colors live. |
| `~/Pictures/wallpapers/` | Put images here with "dark" or "light" in the name to have them auto-swapped. |

---

## 🛠 Troubleshooting
*   **Icons look weird?** Check `~/.config/kitty/kitty.conf`. I've added a `symbol_map` that forces Kitty to use "JetBrainsMono Nerd Font" for icons.
*   **Help menu won't open?** Check `/tmp/hypr_help_debug.log`. It will tell you if it can't find your config file.
*   **Theme didn't swap?** Run `~/.config/hypr/scripts/DarkLight.sh` in a terminal to see the error output.

---

*Stay Antigravity!* 🚀
