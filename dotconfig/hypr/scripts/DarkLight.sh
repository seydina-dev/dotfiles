# This script toggles the entire system between Dark and Light modes.
# It updates configurations for Waybar, Wofi, Mako, Kitty, Helix, and GTK.
# It also attempts to find a matching wallpaper in ~/Pictures/wallpapers.

# Configuration paths
HYPR_SCRIPTS="$HOME/.config/hypr/scripts"
WOFI_DIR="$HOME/.config/wofi"
WAYBAR_DIR="$HOME/.config/waybar"
MAKO_DIR="$HOME/.config/mako"
KITTY_DIR="$HOME/.config/kitty"
HELIX_CONFIG="$HOME/.config/helix/config.toml"

# Determine current mode
if [ ! -f ~/.wallpaper_mode ]; then
    echo "dark" > ~/.wallpaper_mode
fi

CURRENT_MODE=$(cat ~/.wallpaper_mode)

if [ "$CURRENT_MODE" = "light" ]; then
    NEXT_MODE="dark"
    GTK_THEME="Catppuccin-Mocha-Standard-Mauve-dark"
    ICON_THEME="Shiny-Dark-Icons"
    HELIX_THEME="tokyonight"
else
    NEXT_MODE="light"
    GTK_THEME="Catppuccin-Latte-Standard-Mauve-light"
    ICON_THEME="Shiny-Light-Icons"
    HELIX_THEME="tokyonight_day"
fi

# 1. Update Symlinks (The core of the theme system)
# We swap the active 'style.css' or 'config' with the mode-specific version using relative symlinks
# so that host-specific absolute paths do not leak into dotfiles git tracking
[ -d "$WOFI_DIR" ] && (cd "$WOFI_DIR" && ln -sf "styles/style-${NEXT_MODE}.css" "style.css")
[ -d "$WAYBAR_DIR" ] && (cd "$WAYBAR_DIR" && ln -sf "styles/style-${NEXT_MODE}.css" "style.css")
[ -d "$MAKO_DIR" ] && (cd "$MAKO_DIR" && ln -sf "styles/config-${NEXT_MODE}" "config")
[ -d "$KITTY_DIR" ] && (cd "$KITTY_DIR" && ln -sf "themes/${NEXT_MODE}.conf" "current-theme.conf")

# 2. GTK / Icons (Tells desktop apps like Thunar or Settings to change)
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME"
gsettings set org.gnome.desktop.interface icon-theme "$ICON_THEME"
gsettings set org.gnome.desktop.interface color-scheme "prefer-${NEXT_MODE}"

# 3. Helix Theme (Uses sed to edit the config file directly)
sed -i "s/theme = \".*\"/theme = \"$HELIX_THEME\"/" "$HELIX_CONFIG"

# 4. Notify
notify-send -h string:x-canonical-private-synchronous:sys-notify "System Theme" "Switching to ${NEXT_MODE} mode"

# 5. Reload Apps
# Reload Waybar and Mako
killall waybar mako
${HYPR_SCRIPTS}/Waybar.sh &
${HYPR_SCRIPTS}/Mako.sh &

# Reload Kitty (send signal to all running kitty instances to reload config)
killall -USR1 kitty

# 6. Wallpaper (Optional/Dynamic)
WALLPAPER_PATH="$HOME/Pictures/wallpapers"
if [ -d "$WALLPAPER_PATH" ]; then
    NEXT_WALL=$(find "$WALLPAPER_PATH" -type f \( -iname "*${NEXT_MODE}*" \) | shuf -n1)
    if [ -n "$NEXT_WALL" ]; then
        awww img "$NEXT_WALL" --transition-type grow --transition-pos "$(hyprctl cursorpos | sed 's/,//' || echo "0,0")" --transition-duration 2
        echo "$NEXT_WALL" > ~/.current_wallpaper
    fi
fi

# Save state
echo "$NEXT_MODE" > ~/.wallpaper_mode
