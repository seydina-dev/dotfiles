-- Autostart Commands
-- Migrated from Execs.conf (Hyprland 0.55+ Lua config)
-- https://wiki.hypr.land/Configuring/Basics/Autostart/
-- All exec-once commands are registered on the hyprland.start event.

local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"

hl.on("hyprland.start", function()
    -- Wallpaper (using awww utility)
    hl.exec_cmd("awww query || awww img " .. os.getenv("HOME") .. "/Pictures/Wallpapers/groot_1.jpg")
    -- hl.exec_cmd("awww-daemon")
    -- hl.exec_cmd(scriptsDir .. "/Wallpaper.sh")  -- swaybg random wallpaper

    -- DBus / Wayland session environment propagation
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    -- hl.exec_cmd("dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- XDG portals
    -- hl.exec_cmd(scriptsDir .. "/portal-arch-hyprland")
    -- hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
    hl.exec_cmd("sleep 1 && /usr/lib/xdg-desktop-portal")

    -- PipeWire PulseAudio compatibility
    hl.exec_cmd("pipewire-pulse")

    -- Hide the mouse cursor when idling
    hl.exec_cmd("unlutter")

    -- Wallpaper daemon
    hl.exec_cmd("awww-daemon")

    -- Blue-light filter / night mode
    hl.exec_cmd("hyprsunset")

    -- Status bar
    hl.exec_cmd("waybar")
    -- hl.exec_cmd(scriptsDir .. "/Startup.sh")

    -- System tray applets
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("nm-applet --indicator")
    -- hl.exec_cmd("rog-control-center")

    -- Clipboard history manager
    hl.exec_cmd("wl-paste --watch cliphist store")

    -- Scratchpad manager
    -- Native scratchpads used instead
end)
