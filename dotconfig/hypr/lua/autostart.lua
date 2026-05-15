-- Autostart / exec-once
-- Replaces configs/Execs.conf
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    -- Wallpaper (awww): resume existing instance or set a default
    hl.exec_cmd("awww query || awww img $HOME/Pictures/Wallpapers/groot_1.jpg")

    -- D-Bus / systemd environment propagation
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- XDG desktop portals
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland &")
    hl.exec_cmd("sleep 1 && /usr/lib/xdg-desktop-portal &")

    -- Audio
    hl.exec_cmd("pipewire-pulse &")

    -- Hide mouse cursor when idle
    hl.exec_cmd("unlutter &")

    -- awww daemon (wallpaper transitions)
    hl.exec_cmd("awww-daemon &")

    -- Night light
    hl.exec_cmd("hyprsunset")

    -- Status bar
    hl.exec_cmd("waybar")

    -- System tray applets
    hl.exec_cmd("blueman-applet &")
    hl.exec_cmd("nm-applet --indicator &")

    -- Clipboard manager
    hl.exec_cmd("wl-paste --watch cliphist store")

    -- Scratchpad daemon
    hl.exec_cmd("hyprscratch init clean eager")
end)
