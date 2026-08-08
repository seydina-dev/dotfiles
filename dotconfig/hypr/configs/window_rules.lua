-- Window Rules
-- Migrated from WindowRules.v2.conf (Hyprland 0.55+ Lua config)
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- Rules are evaluated top-to-bottom; last match wins for each effect.

-- =========================================================
-- Floating windows
-- =========================================================

hl.window_rule({ match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, float = true })
hl.window_rule({ match = { class = "^(nm-connection-editor|blueman-manager|overskride)$" }, float = true })
hl.window_rule({ match = { class = "^(swayimg|vlc|Viewnior|pavucontrol)$" }, float = true })
hl.window_rule({ match = { class = "^(nwg-look|qt5ct|mpv)$" }, float = true })
hl.window_rule({ match = { class = "^(onedriver|onedriver-launcher)$" }, float = true })
hl.window_rule({ match = { class = "^(zoom)$" }, float = true })
hl.window_rule({ match = { class = "^(scrcpy)$" }, float = true })
hl.window_rule({ match = { class = "^(wofi)$" }, float = true })

-- =========================================================
-- Game / special fullscreen
-- =========================================================

hl.window_rule({ match = { class = "^(gamescope)$" }, no_blur = true })
hl.window_rule({ match = { class = "^(gamescope)$" }, fullscreen = true })
-- gamescope → workspace 6, silently
hl.window_rule({ match = { class = "^(gamescope)$" }, workspace = "6 silent" })

-- =========================================================
-- Workspace + floating combined
-- =========================================================

-- scrcpy: workspace 3 AND float
hl.window_rule({ match = { class = "^(scrcpy)$", float = true }, workspace = "3 silent" })

-- =========================================================
-- Suppress maximize request from any window
-- =========================================================

-- windowrule = suppress_event maximize, match:class .*
-- Lua equivalent: suppress the maximize client request globally
hl.window_rule({
    match = { class = ".*" },
suppress_event = "maximize"
})

-- =========================================================
-- No focus for empty/unmanaged XWayland popups
-- =========================================================

hl.window_rule({
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- =========================================================
-- Workspace assignments (silent unless noted)
-- =========================================================

hl.window_rule({ match = { class = "^(firefox)$" },                                            workspace = "2 silent"  })
hl.window_rule({ match = { class = "^(google-chrome)$" },                                      workspace = "4 silent"  })
hl.window_rule({ match = { class = "^(obsidian)$" },                                           workspace = "5 silent"  })
hl.window_rule({ match = { class = "^(Zed)$", title = "^(Zed)$" },                            workspace = "5 silent"  })
hl.window_rule({ match = { class = "^(thunar)$" },                                             workspace = "3 silent"  })
hl.window_rule({ match = { class = "^(thunderbird)$" },                                        workspace = "1 silent"  })
hl.window_rule({ match = { class = "^(com.obsproject.Studio)$" },                              workspace = "4 silent"  })
hl.window_rule({ match = { class = "^(Steam)$", title = "^(Steam)$" },                        workspace = "5 silent"  })
hl.window_rule({ match = { class = "^(lutris)$" },                                             workspace = "5 silent"  })
hl.window_rule({ match = { class = "^(virt-manager)$" },                                      workspace = "6 silent"  })
hl.window_rule({ match = { class = "^(discord)$" },                                            workspace = "7 silent"  })
hl.window_rule({ match = { class = "^(audacious)$" },                                         workspace = "9 silent"  })

-- =========================================================
-- Opacity rules
-- =========================================================

hl.window_rule({ match = { class = "^(firefox)$" },           opacity = "0.9 0.7"   })
hl.window_rule({ match = { class = "^(thunar)$" },            opacity = "1.0 0.8"   })
hl.window_rule({ match = { class = "^(foot)$" },              opacity = "0.7 0.7"   })
hl.window_rule({ match = { class = "^(mousepad)$" },          opacity = "0.9 0.7"   })
hl.window_rule({ match = { class = "^(codium-url-handler)$" }, opacity = "0.9 0.7"  })
hl.window_rule({ match = { class = "^(VSCodium)$" },          opacity = "0.9 0.7"   })

-- Pinned windows: active 1.0, inactive 0.6
hl.window_rule({ match = { pin = true }, opacity = "1.0 0.6" })

-- =========================================================
-- Border color effects
-- =========================================================

-- Red/dark-red border when fullscreen
hl.window_rule({
    match        = { fullscreen = true },
    border_color = "rgb(EE4B55) rgb(880808) 45deg",
})

-- Commented out: custom float border
-- hl.window_rule({
--     match        = { float = true },
--     border_color = { colors = { "rgb(282737)", "rgb(1E1D2D)" } },
-- })

-- =========================================================
-- Layer rules (waybar etc.)
-- =========================================================

-- Uncomment to add blur to waybar:
-- hl.layer_rule({ match = { namespace = "waybar" }, blur = true })


-- =========================================================
-- Native Scratchpads (Special Workspaces)
-- =========================================================

hl.workspace_rule({ workspace = "special:terminal", on_created_empty = "kitty --class scratch_term --title terminal" })
hl.window_rule({ match = { class = "scratch_term" }, float = true })
hl.window_rule({ match = { class = "scratch_term" }, size = "70% 80%" })
hl.window_rule({ match = { class = "scratch_term" }, center = true })

hl.workspace_rule({ workspace = "special:config", on_created_empty = "kitty --class scratch_config --title config -e helix " .. os.getenv("HOME") .. "/.config/hypr" })
hl.window_rule({ match = { class = "scratch_config" }, float = true })
hl.window_rule({ match = { class = "scratch_config" }, size = "70% 80%" })
hl.window_rule({ match = { class = "scratch_config" }, center = true })

hl.workspace_rule({ workspace = "special:yazi", on_created_empty = "kitty --class scratch_yazi --title yazi -e yazi" })
hl.window_rule({ match = { class = "scratch_yazi" }, float = true })
hl.window_rule({ match = { class = "scratch_yazi" }, size = "70% 80%" })
hl.window_rule({ match = { class = "scratch_yazi" }, center = true })

hl.workspace_rule({ workspace = "special:scrcpy", on_created_empty = "scrcpy" })
hl.window_rule({ match = { class = "scrcpy", workspace = "special:scrcpy" }, float = true })
hl.window_rule({ match = { class = "scrcpy", workspace = "special:scrcpy" }, center = true })