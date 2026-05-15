-- Keybindings
-- Replaces configs/Keybinds.conf
-- See https://wiki.hypr.land/Configuring/Basics/Binds/

local mainMod   = "SUPER"
local customMod = "ALT"

-- Application variables
local term        = "kitty"
local files       = "thunar"
local browser     = "google-chrome-stable"
local scriptsDir  = os.getenv("HOME") .. "/.config/hypr/scripts"
local localbinDir = os.getenv("HOME") .. "/.local/bin"

-- Script shortcuts
local function script(name) return scriptsDir .. "/" .. name end
local function localbin(name) return localbinDir .. "/" .. name end

local AirplaneMode      = script("AirplaneMode.sh")
local backlight         = script("Brightness.sh")
local kbacklight        = script("BrightnessKbd.sh")
local ChangeBlur        = script("ChangeBlur.sh")
local ChangeLayout      = script("ChangeLayout.sh")
local ChangeLayoutMenu  = script("ChangeLayoutMenu.sh")
local DarkLight         = script("DarkLight.sh")
local GameMode          = script("GameMode.sh")
local Help              = script("Help.sh")
local LidSwitch         = script("LidSwitch.sh")
local LockScreen        = script("LockScreen.sh")
local Mako              = script("Mako.sh")
local screenshot        = script("ScreenShot.sh")
local touchpad          = script("TouchPad.sh")
local volume            = script("Volume.sh")
local wallpaper         = script("Wallpaper.sh")
local wallpaperSelect   = script("WallpaperSelect.sh")
local waybar            = script("Waybar.sh")
local waybarStyle       = script("WaybarStyles.sh")
local Wofi              = script("Wofi.sh")
local WofiBig           = script("WofiBig.sh")
local WofiBeats         = script("WofiBeats.sh")
local Clipboard         = script("ClipManager.sh")
local restartWaybar     = os.getenv("HOME") .. "/.config/waybar/scripts/launcher.sh"

---------------------------------------
-- General binds
---------------------------------------

hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd(WofiBig))
hl.bind(mainMod .. " + D",         hl.dsp.exec_cmd(Wofi))
hl.bind(mainMod .. " + Q",         hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + M",         hl.dsp.exec_cmd("hyprctl dispatch splitratio 0.3"))
hl.bind(mainMod .. " + Return",    hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + T",         hl.dsp.exec_cmd(files))
hl.bind(mainMod .. " + R",         hl.dsp.exec_cmd(restartWaybar))
hl.bind(mainMod .. " + W",         hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + O",         hl.dsp.exec_cmd("obsidian ~/code/docs"))
hl.bind(mainMod .. " + CTRL + S",  hl.dsp.exec_cmd(WofiBeats))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(wallpaper))
hl.bind(mainMod .. " + CTRL + W",  hl.dsp.exec_cmd(wallpaperSelect))
hl.bind(mainMod .. " + H",         hl.dsp.exec_cmd(Help))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(DarkLight))
hl.bind(mainMod .. " + B",         hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd(GameMode))
hl.bind(mainMod .. " + Escape",    hl.dsp.exec_cmd("hyprctl kill"))
-- hl.bind("CTRL + " .. mainMod .. " + L", hl.dsp.exec_cmd(LockScreen))

---------------------------------------
-- Layout management
---------------------------------------

hl.bind(mainMod .. " + CTRL + D",     hl.dsp.layout("removemaster"))
hl.bind(mainMod .. " + I",            hl.dsp.layout("addmaster"))
hl.bind(mainMod .. " + J",            hl.dsp.layout("cyclenext"))
hl.bind(mainMod .. " + K",            hl.dsp.layout("cycleprev"))
hl.bind(mainMod .. " + P",            hl.dsp.layout("rotatesplit"))  -- dwindle: rotate split direction (0.55+)
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.layout("swapwithmaster"))
hl.bind(mainMod .. " + Space",         hl.dsp.exec_cmd(ChangeLayout))

---------------------------------------
-- Special keys / hotkeys
---------------------------------------

hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd(volume .. " --inc"),        { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd(volume .. " --dec"),        { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd(volume .. " --toggle-mic"), { locked = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd(volume .. " --toggle"),     { locked = true })
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd(kbacklight .. " --dec"),   { locked = true, repeating = true })
hl.bind("XF86KbdBrightnessUp",   hl.dsp.exec_cmd(kbacklight .. " --inc"),   { locked = true, repeating = true })
hl.bind("XF86Launch3",           hl.dsp.exec_cmd("asusctl led-mode -n"),     { locked = true })  -- FN+F4 keyboard RGB
hl.bind("XF86Launch4",           hl.dsp.exec_cmd("asusctl profile -n"),      { locked = true })  -- FN+F5 fan profile
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(backlight .. " --dec"),     { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd(backlight .. " --inc"),     { locked = true, repeating = true })
hl.bind("XF86TouchpadToggle",    hl.dsp.exec_cmd(touchpad),                  { locked = true })
hl.bind("XF86Launch1",           hl.dsp.exec_cmd("rog-control-center"))       -- ASUS Armory Crate
hl.bind("XF86Sleep",             hl.dsp.exec_cmd(LockScreen))                -- FN+F11 sleep button
hl.bind("XF86Rfkill",            hl.dsp.exec_cmd(AirplaneMode))              -- FN+F12 airplane mode

-- Media keys
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
hl.bind("XF86AudioStop",  hl.dsp.exec_cmd("playerctl stop"),       { locked = true })

-- Lid switch
hl.bind("switch:Lid Switch", hl.dsp.exec_cmd(LidSwitch), { locked = true })

---------------------------------------
-- Window resize (vim style)
---------------------------------------

hl.bind(mainMod .. " + SHIFT + H",     hl.dsp.window.resize({ x = -50, y = 0 }),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + L",     hl.dsp.window.resize({ x =  50, y = 0 }),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + K",     hl.dsp.window.resize({ x = 0, y = -50 }),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + J",     hl.dsp.window.resize({ x = 0, y =  50 }),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -50, y = 0 }),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x =  50, y = 0 }),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize({ x = 0, y = -50 }),  { repeating = true })
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize({ x = 0, y =  50 }),  { repeating = true })

---------------------------------------
-- Window move (vim style)
---------------------------------------

hl.bind(mainMod .. " + CTRL + H",     hl.dsp.window.move({ direction = "left"  }))
hl.bind(mainMod .. " + CTRL + L",     hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + K",     hl.dsp.window.move({ direction = "up"    }))
hl.bind(mainMod .. " + CTRL + J",     hl.dsp.window.move({ direction = "down"  }))
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.move({ direction = "left"  }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.move({ direction = "up"    }))
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.move({ direction = "down"  }))

---------------------------------------
-- Focus
---------------------------------------

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down"  }))

---------------------------------------
-- Workspaces (loop 1-10)
---------------------------------------

for i = 1, 10 do
    local key = i % 10  -- 10 maps to key 0
    -- Switch to workspace
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    -- Move window to workspace (follow)
    hl.bind(mainMod .. " + CTRL + " .. key,  hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace " .. i))
    -- Move window to workspace silently (no follow)
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent " .. i))
end

-- Previous/next workspace (relative, move window)
hl.bind(mainMod .. " + CTRL + bracketleft",   hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace -1"))
hl.bind(mainMod .. " + CTRL + bracketright",  hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace +1"))
hl.bind(mainMod .. " + SHIFT + bracketleft",  hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent -1"))
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent +1"))

-- Scroll through workspaces with mainMod + scroll / period / comma
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + period",     hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + comma",      hl.dsp.focus({ workspace = "e-1" }))

-- Monitor workspace cycling
hl.bind(mainMod .. " + tab",         hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }))

---------------------------------------
-- Special workspace (scratchpad)
---------------------------------------

hl.bind(mainMod .. " + U",         hl.dsp.workspace.toggle_special())
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special" }))

---------------------------------------
-- Groups
---------------------------------------

hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("hyprctl dispatch togglegroup"))

---------------------------------------
-- Mouse window management
---------------------------------------

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

---------------------------------------
-- Screenshots
---------------------------------------

hl.bind(mainMod .. " + Print",              hl.dsp.exec_cmd(screenshot .. " --now"))
hl.bind(mainMod .. " + CTRL + SHIFT + Print", hl.dsp.exec_cmd(screenshot .. " --in5"))
hl.bind(mainMod .. " + SHIFT + Print",      hl.dsp.exec_cmd(screenshot .. " --area"))
hl.bind(mainMod .. " + SHIFT + S",          hl.dsp.exec_cmd("hyprshot -m region"))

-- Asus G15 (no PrintSrc button)
hl.bind(mainMod .. " + F6",              hl.dsp.exec_cmd(screenshot .. " --now"))
hl.bind(mainMod .. " + SHIFT + F6",      hl.dsp.exec_cmd(screenshot .. " --area"))
hl.bind(mainMod .. " + CTRL + SHIFT + F6", hl.dsp.exec_cmd(screenshot .. " --in5"))

---------------------------------------
-- Scratchpads (hyprscratch)
---------------------------------------

hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(
    "hyprscratch terminal '[size 70% 80%] kitty --title terminal' persist pin"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(
    "hyprscratch config '[size 70% 80%] kitty --title config -e helix ~/.config/hypr' persist pin"))
hl.bind(customMod .. " + Y", hl.dsp.exec_cmd(
    "hyprscratch yazi '[size 70% 80%] kitty --title yazi -e yazi' persist pin"))
hl.bind(customMod .. " + A", hl.dsp.exec_cmd(
    "hyprscratch scrcpy 'scrcpy' persist pin"))

---------------------------------------
-- Workspace: move window to named ws
---------------------------------------

hl.bind(mainMod .. " + SHIFT + I", hl.dsp.window.move({ workspace = "terminal" }))
