-- Environment variables
-- Replaces configs/ENVariables.conf
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")   -- necessary to run qt5ct properly
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- NVIDIA
-- Uncomment if you need software cursors (WLR_NO_HARDWARE_CURSORS was wlroots-era, removed)
-- hl.env("HYPRLAND_NO_HW_CURSORS", "1")
-- hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- hl.env("MOZ_ENABLE_WAYLAND", "1")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- hl.env("GBM_BACKEND", "nvidia-drm")  -- causes crashes, use with care
-- hl.env("__NV_PRIME_RENDER_OFFLOAD", "1")
-- hl.env("__VK_LAYER_NV_optimus", "NVIDIA_only")
-- hl.env("NVD_BACKEND", "direct")
