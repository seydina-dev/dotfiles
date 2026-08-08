-- Hyprland Configuration Entry Point
-- Migrated from hyprland.conf (Hyprland 0.55+ Lua config)
-- https://wiki.hypr.land/Configuring/

local hyprDir = os.getenv("HOME") .. "/.config/hypr"

-- =========================================================
-- Sub-modules
-- =========================================================

dofile(hyprDir .. "/configs/env.lua")
dofile(hyprDir .. "/configs/monitors.lua")
dofile(hyprDir .. "/configs/autostart.lua")
dofile(hyprDir .. "/configs/keybinds.lua")
dofile(hyprDir .. "/configs/window_rules.lua")


-- =========================================================
-- Animations & Curves
-- =========================================================

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

-- =========================================================
-- Permissions
-- =========================================================

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Permission changes require a Hyprland restart.

-- hl.config({
--     ecosystem = { enforce_permissions = true },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim",                                    "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland",         "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm",                                  "plugin",     "allow")

-- =========================================================
-- Look and Feel
-- =========================================================

-- https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 20,

        border_size = 2,

        -- Active border: cyan→green gradient at 45°
        ["col.active_border"]   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
        ["col.inactive_border"] = "rgba(595959aa)",

        -- Click-and-drag border/gap resizing
        resize_on_border = false,

        -- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    -- -------------------------------------------------------
    -- Animations
    -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
    -- -------------------------------------------------------
    animations = {
        enabled = true,
    },

    -- -------------------------------------------------------
    -- Layouts
    -- -------------------------------------------------------

    -- https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
    dwindle = {
        preserve_split = true,
    },

    -- https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
    master = {
        new_status = "master",
    },

    -- -------------------------------------------------------
    -- Miscellaneous
    -- https://wiki.hypr.land/Configuring/Basics/Variables/#misc
    -- -------------------------------------------------------
    misc = {
        force_default_wallpaper = -1,   -- -1 = show anime wallpaper, 0/1 = disable
        disable_hyprland_logo   = false,
    },

    -- -------------------------------------------------------
    -- Input
    -- https://wiki.hypr.land/Configuring/Basics/Variables/#input
    -- -------------------------------------------------------
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,   -- -1.0–1.0; 0 = no modification

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- =========================================================
-- Gestures
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
-- =========================================================

-- 3-finger horizontal swipe → switch workspace
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- =========================================================
-- Per-device input config
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
-- =========================================================

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})
