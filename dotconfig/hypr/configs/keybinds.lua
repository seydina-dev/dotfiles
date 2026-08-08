-- Keybindings
-- Migrated from Keybinds.conf (Hyprland 0.55+ Lua config)
-- https://wiki.hypr.land/Configuring/Basics/Binds/

local home       = os.getenv("HOME")
local scriptsDir = home .. "/.config/hypr/scripts"
local localbinDir = home .. "/.local/bin"

-- Modifier aliases
local mainMod   = "SUPER"
local customMod = "ALT"

-- App aliases
local files   = "thunar"
local browser = "google-chrome-stable"
local term    = "kitty"

-- Script aliases
local restartWaybar    = home .. "/.config/waybar/scripts/launcher.sh"
local AirplaneMode     = scriptsDir .. "/AirplaneMode.sh"
local backlight        = scriptsDir .. "/Brightness.sh"
local kbacklight       = scriptsDir .. "/BrightnessKbd.sh"
local ChangeLayout     = scriptsDir .. "/ChangeLayout.sh"
local ChangeLayoutMenu = scriptsDir .. "/ChangeLayoutMenu.sh"
local DarkLight        = scriptsDir .. "/DarkLight.sh"
local GameMode         = scriptsDir .. "/GameMode.sh"
local Help             = scriptsDir .. "/Help.sh"
local LidSwitch        = scriptsDir .. "/LidSwitch.sh"
local LockScreen       = scriptsDir .. "/LockScreen.sh"
local screenshot       = scriptsDir .. "/ScreenShot.sh"
local touchpad         = scriptsDir .. "/TouchPad.sh"
local volume           = scriptsDir .. "/Volume.sh"
local wallpaper        = scriptsDir .. "/Wallpaper.sh"
local wallpaperSelect  = scriptsDir .. "/WallpaperSelect.sh"
local Wofi             = scriptsDir .. "/Wofi.sh"
local WofiBig          = scriptsDir .. "/WofiBig.sh"
local WofiBeats        = scriptsDir .. "/WofiBeats.sh"
local Clipboard        = scriptsDir .. "/ClipManager.sh"

-- =========================================================
-- Core WM
-- =========================================================

hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + Q",         hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + M",         hl.dsp.exit())
hl.bind(mainMod .. " + Escape",    hl.dsp.exec_cmd("hyprctl kill"))

-- =========================================================
-- App launchers
-- =========================================================

hl.bind(mainMod .. " + Return",      hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + D",           hl.dsp.exec_cmd(Wofi))
hl.bind(mainMod .. " + SHIFT + D",   hl.dsp.exec_cmd(WofiBig))
hl.bind(mainMod .. " + W",           hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + T",           hl.dsp.exec_cmd(files))
hl.bind(mainMod .. " + O",           hl.dsp.exec_cmd("obsidian " .. home .. "/code/docs"))
hl.bind(mainMod .. " + R",           hl.dsp.exec_cmd(restartWaybar))
hl.bind(mainMod .. " + CTRL + S",    hl.dsp.exec_cmd(WofiBeats))
hl.bind(mainMod .. " + SHIFT + W",   hl.dsp.exec_cmd(wallpaper))
hl.bind(mainMod .. " + CTRL + W",    hl.dsp.exec_cmd(wallpaperSelect))
hl.bind(mainMod .. " + H",           hl.dsp.exec_cmd(Help))
hl.bind(mainMod .. " + SHIFT + T",   hl.dsp.exec_cmd(DarkLight))
hl.bind(mainMod .. " + B",           hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.bind(mainMod .. " + SHIFT + G",   hl.dsp.exec_cmd(GameMode))

-- =========================================================
-- Layout management
-- =========================================================

hl.bind(mainMod .. " + CTRL + D",    hl.dsp.layout("removemaster"))
hl.bind(mainMod .. " + I",           hl.dsp.layout("addmaster"))
hl.bind(mainMod .. " + J",           hl.dsp.layout("cyclenext"))
hl.bind(mainMod .. " + K",           hl.dsp.layout("cycleprev"))
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.layout("swapwithmaster"))
hl.bind(mainMod .. " + Space",       hl.dsp.exec_cmd(ChangeLayout))
hl.bind(mainMod .. " + P",           hl.dsp.layout("rotatesplit"))  -- dwindle: rotate split direction
hl.bind(mainMod .. " + G",           hl.dsp.group.toggle())

-- =========================================================
-- Window resize (vim-style, repeating)
-- =========================================================

hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.window.resize({ x = -50, y = 0,   relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + L",     hl.dsp.window.resize({ x = 50,  y = 0,   relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + K",     hl.dsp.window.resize({ x = 0,   y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + J",     hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }), { repeating = true })

hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -50, y = 0,   relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 50,  y = 0,   relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize({ x = 0,   y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }), { repeating = true })

-- =========================================================
-- Window move (vim-style)
-- =========================================================

hl.bind(mainMod .. " + CTRL + H",     hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + L",     hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + K",     hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + J",     hl.dsp.window.move({ direction = "d" }))

hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.move({ direction = "d" }))

-- =========================================================
-- Focus (arrow keys)
-- =========================================================

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))

-- =========================================================
-- Special workspace (scratchpad)
-- =========================================================

hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special", follow = true }))
hl.bind(mainMod .. " + U",         hl.dsp.workspace.toggle_special(""))

-- =========================================================
-- Workspace switching (1–10)
-- =========================================================

for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i,              hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind(mainMod .. " + CTRL + " .. i,       hl.dsp.window.move({ workspace = tostring(i), follow = true }))
    hl.bind(mainMod .. " + SHIFT + " .. i,      hl.dsp.window.move({ workspace = tostring(i), follow = false }))
end
hl.bind(mainMod .. " + 0",              hl.dsp.focus({ workspace = "10" }))
hl.bind(mainMod .. " + CTRL + 0",       hl.dsp.window.move({ workspace = "10", follow = true }))
hl.bind(mainMod .. " + SHIFT + 0",      hl.dsp.window.move({ workspace = "10", follow = false }))

-- Relative workspace navigation
hl.bind(mainMod .. " + CTRL + bracketleft",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + bracketright", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + bracketleft",  hl.dsp.window.move({ workspace = "-1", follow = false }))
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1", follow = false }))

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + period",     hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + comma",      hl.dsp.focus({ workspace = "e-1" }))

-- Cycle workspaces on current monitor
hl.bind(mainMod .. " + Tab",        hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }))

-- Also cycle focus (Tab = next window, SUPER+SHIFT+Tab = bring to top)
hl.bind(mainMod .. " + Tab",        hl.dsp.window.cycle_next())
hl.bind("SUPER + SHIFT + Tab",      hl.dsp.window.bring_to_top())

-- =========================================================
-- Mouse window management
-- =========================================================

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })  -- LMB: move
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })  -- RMB: resize

-- =========================================================
-- Screenshots
-- =========================================================

hl.bind(mainMod .. " + Print",              hl.dsp.exec_cmd(screenshot .. " --now"))
hl.bind(mainMod .. " + CTRL + SHIFT + Print", hl.dsp.exec_cmd(screenshot .. " --in5"))
hl.bind(mainMod .. " + SUPER + Print",      hl.dsp.exec_cmd(screenshot .. " --in10"))
hl.bind(mainMod .. " + SHIFT + Print",      hl.dsp.exec_cmd(screenshot .. " --area"))
hl.bind(mainMod .. " + SHIFT + S",          hl.dsp.exec_cmd("hyprshot -m region"))

-- Screenshot binds for ASUS G15 (no PrintSrc button)
hl.bind(mainMod .. " + F6",              hl.dsp.exec_cmd(screenshot .. " --now"))
hl.bind(mainMod .. " + SHIFT + F6",     hl.dsp.exec_cmd(screenshot .. " --area"))
hl.bind(mainMod .. " + CTRL + SHIFT + F6", hl.dsp.exec_cmd(screenshot .. " --in5"))
hl.bind(mainMod .. " + SUPER + F6",     hl.dsp.exec_cmd(screenshot .. " --in10"))

-- =========================================================
-- Scratchpads (hyprscratch)
-- =========================================================

hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("hyprscratch terminal \"[size 70% 80%] kitty --title terminal\" persist pin"))
hl.bind(mainMod .. " + C",             hl.dsp.exec_cmd("hyprscratch config \"[size 70% 80%] kitty --title config -e helix ~/.config/hypr\" persist pin"))
hl.bind(customMod .. " + Y",           hl.dsp.exec_cmd("hyprscratch yazi \"[size 70% 80%] kitty --title yazi -e yazi\" persist pin"))
hl.bind(customMod .. " + A",           hl.dsp.exec_cmd("hyprscratch scrcpy \"scrcpy\" persist pin"))

-- =========================================================
-- Special / Function keys (ASUS ROG + Fn keys)
-- =========================================================

-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volume .. " --inc"),        { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volume .. " --dec"),        { repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd(volume .. " --toggle-mic"))
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(volume .. " --toggle"),     { locked = true })

-- Keyboard backlight (FN+F2 / FN+F3)
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd(kbacklight .. " --dec"))
hl.bind("XF86KbdBrightnessUp",   hl.dsp.exec_cmd(kbacklight .. " --inc"))

-- ASUS-specific keys
hl.bind("XF86Launch1",  hl.dsp.exec_cmd("rog-control-center"))              -- Armory Crate button
hl.bind("XF86Launch3",  hl.dsp.exec_cmd("asusctl led-mode -n"))             -- FN+F4: cycle keyboard RGB
hl.bind("XF86Launch4",  hl.dsp.exec_cmd("asusctl profile -n"))              -- FN+F5: cycle fan profiles

-- Monitor brightness (FN+F7 / FN+F8)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(backlight .. " --dec"))
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(backlight .. " --inc"))

-- Touchpad toggle (FN+F10)
hl.bind("XF86TouchpadToggle", hl.dsp.exec_cmd(touchpad))

-- Sleep / Airplane mode
hl.bind("XF86Sleep",   hl.dsp.exec_cmd(LockScreen), { locked = true })      -- FN+F11
hl.bind("XF86Rfkill",  hl.dsp.exec_cmd(AirplaneMode))                       -- FN+F12

-- Lid switch (triggered when external monitor is connected and lid closes)
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd(LidSwitch), { locked = true })

-- Media keys
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"),    { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"),        { locked = true })

-- =========================================================
-- Move to terminal workspace
-- =========================================================

hl.bind(mainMod .. " + SHIFT + I", hl.dsp.window.move({ workspace = "terminal", follow = true }))
