-- Window rules
-- Replaces configs/WindowRules.v2.conf
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Floating rules
hl.window_rule({ name = "float-polkit",     match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, float = true })
hl.window_rule({ name = "float-nm-bt",      match = { class = "^(nm-connection-editor|blueman-manager|overskride)$" }, float = true })
hl.window_rule({ name = "float-media",      match = { class = "^(swayimg|vlc|Viewnior|pavucontrol)$" }, float = true })
hl.window_rule({ name = "float-theming",    match = { class = "^(nwg-look|qt5ct|mpv)$" }, float = true })
hl.window_rule({ name = "float-onedriver",  match = { class = "^(onedriver|onedriver-launcher)$" }, float = true })
hl.window_rule({ name = "float-zoom",       match = { class = "^(zoom)$" }, float = true })
hl.window_rule({ name = "float-scrcpy",     match = { class = "^(scrcpy)$" }, float = true })
hl.window_rule({ name = "float-wofi",       match = { class = "^(wofi)$" }, float = true })

-- Gamescope
hl.window_rule({ name = "gamescope-noblur",     match = { class = "^(gamescope)$" }, no_blur = true })
hl.window_rule({ name = "gamescope-fullscreen",  match = { class = "^(gamescope)$" }, fullscreen = true })
hl.window_rule({ name = "gamescope-ws",          match = { class = "^(gamescope)$" }, workspace = "6 silent" })
-- Confine pointer in gamescope (new in 0.55)
hl.window_rule({ name = "gamescope-confine",     match = { class = "^(gamescope)$" }, confine_pointer = true })

-- scrcpy: floating + workspace 3
hl.window_rule({ name = "scrcpy-ws",  match = { float = true, class = "^(scrcpy)$" }, workspace = "3" })

-- Global suppress-maximize and XWayland drag fix
hl.window_rule({
    name           = "suppress-maximize",
    match          = { class = ".*" },
    suppress_event = "maximize",
})
hl.window_rule({
    name       = "fix-xwayland-drags",
    match      = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus   = true,
})

-- Workspace assignments
hl.window_rule({ name = "ws-firefox",    match = { class = "^(firefox)$" },                                         workspace = "2" })
hl.window_rule({ name = "ws-chrome",     match = { class = "^(google-chrome)$" },                                   workspace = "4" })
hl.window_rule({ name = "ws-obsidian",   match = { class = "^(obsidian)$" },                                        workspace = "5" })
hl.window_rule({ name = "ws-zed",        match = { class = "^(Zed)$", title = "^(Zed)$" },                          workspace = "5" })
hl.window_rule({ name = "ws-thunar",     match = { class = "^(thunar)$" },                                          workspace = "3" })
hl.window_rule({ name = "ws-thunder",    match = { class = "^(thunderbird)$" },                                      workspace = "1" })
hl.window_rule({ name = "ws-obs",        match = { class = "^(com.obsproject.Studio)$" },                           workspace = "4" })
hl.window_rule({ name = "ws-steam",      match = { class = "^(Steam)$", title = "^(Steam)$" },                      workspace = "5 silent" })
hl.window_rule({ name = "ws-lutris",     match = { class = "^(lutris)$" },                                          workspace = "5 silent" })
hl.window_rule({ name = "ws-virt",       match = { class = "^(virt-manager)$" },                                    workspace = "6" })
hl.window_rule({ name = "ws-discord",    match = { class = "^(discord)$" },                                         workspace = "7 silent" })
hl.window_rule({ name = "ws-audacious",  match = { class = "^(audacious)$" },                                       workspace = "9 silent" })

-- Opacity rules (format: "active inactive")
hl.window_rule({ name = "opacity-firefox",  match = { class = "^(firefox)$" },             opacity = "0.9 0.7" })
hl.window_rule({ name = "opacity-thunar",   match = { class = "^(thunar)$" },              opacity = "1.0 0.8" })
hl.window_rule({ name = "opacity-foot",     match = { class = "^(foot)$" },                opacity = "0.7 0.7" })
hl.window_rule({ name = "opacity-mousepad", match = { class = "^(mousepad)$" },            opacity = "0.9 0.7" })
hl.window_rule({ name = "opacity-codium",   match = { class = "^(codium-url-handler)$" },  opacity = "0.9 0.7" })
hl.window_rule({ name = "opacity-vscodium", match = { class = "^(VSCodium)$" },            opacity = "0.9 0.7" })
hl.window_rule({ name = "opacity-pinned",   match = { pin = true },                        opacity = "1.0 0.6" })

-- Border color for fullscreen windows
hl.window_rule({ name = "border-fullscreen", match = { fullscreen = true }, border_color = { colors = { "rgb(EE4B55)", "rgb(880808)" } } })
-- hl.window_rule({ name = "border-float",   match = { float = true },      border_color = { colors = { "rgb(282737)", "rgb(1E1D2D)" } } })
