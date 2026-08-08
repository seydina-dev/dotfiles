-- Environment Variables
-- Migrated from ENVariables.conf (Hyprland 0.55+ Lua config)
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- Qt theme
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

-- Wayland toolkit backends
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("CLUTTER_BACKEND", "wayland")

-- XDG session / desktop
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

-- Qt scaling and decorations
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Cursor sizes
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- NVIDIA (kept for reference; disabled — caused crashes)
-- WLR_NO_HARDWARE_CURSORS is a wlroots-era variable, no longer needed on Hyprland >= 0.41.
-- If you still need software cursors, use: hl.env("HYPRLAND_NO_HW_CURSORS", "1")
-- hl.env("HYPRLAND_NO_HW_CURSORS", "1")
-- hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- hl.env("MOZ_ENABLE_WAYLAND", "1")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- hl.env("GBM_BACKEND", "nvidia-drm")  -- causes issues like Hyprland crashing
-- hl.env("__NV_PRIME_RENDER_OFFLOAD", "1")
-- hl.env("__VK_LAYER_NV_optimus", "NVIDIA_only")
-- hl.env("WLR_DRM_NO_ATOMIC", "1")
-- hl.env("NVD_BACKEND", "direct")
