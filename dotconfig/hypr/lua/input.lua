-- Input configuration
-- Replaces the input section of hyprland.conf
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,  -- -1.0 to 1.0, 0 means no modification

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- 3-finger horizontal swipe to switch workspaces
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- Per-device config (example entry; adjust name via `hyprctl devices`)
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

-- Touchpad device used by TouchPad.sh toggle script:
--   "asue1209:00-04f3:319f-touchpad"
-- No static config needed here since the script handles enable/disable at runtime
-- via `hyprctl keyword device:...:enabled`
