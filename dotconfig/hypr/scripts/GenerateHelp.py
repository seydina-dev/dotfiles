#!/usr/bin/env python3
import os
import re
import sys

# Debug log
LOG_PATH = "/tmp/hypr_help_debug.log"

def log(msg):
    with open(LOG_PATH, "a") as f:
        f.write(msg + "\n")

# Clear old log
with open(LOG_PATH, "w") as f:
    f.write("--- Help Generator Log ---\n")

# Try multiple possible locations for the config file (prefer Lua over legacy conf)
POSSIBLE_PATHS = [
    os.path.expanduser("~/.config/hypr/configs/keybinds.lua"),
    os.path.expanduser("~/dotfiles/dotconfig/hypr/configs/keybinds.lua"),
    os.path.expanduser("~/.config/hypr/configs/Keybinds.conf"),
    os.path.expanduser("~/dotfiles/dotconfig/hypr/configs/Keybinds.conf"),
]

CONFIG_PATH = None
for path in POSSIBLE_PATHS:
    log(f"Checking path: {path}")
    if os.path.exists(path):
        CONFIG_PATH = path
        log(f"Found config at: {CONFIG_PATH}")
        break

OUTPUT_PATH = "/tmp/hypr_help.md"

VAR_MAP = {
    "mainMod": "SUPER",
    "customMod": "ALT",
    "term": "kitty",
    "files": "thunar",
    "browser": "google-chrome-stable",
    "restartWaybar": "Restart Waybar",
    "screenshot": "ScreenShot",
    "volume": "Volume",
    "wallpaper": "Wallpaper",
    "wallpaperSelect": "WallpaperSelect",
    "Wofi": "Wofi",
    "WofiBig": "WofiBig",
    "WofiBeats": "WofiBeats",
    "Help": "Help Menu",
    "DarkLight": "Dark/Light Mode Toggle",
    "GameMode": "Game Mode Toggle",
    "AirplaneMode": "Airplane Mode Toggle",
    "LockScreen": "Lock Screen",
    "LidSwitch": "Lid Switch",
    "touchpad": "Touchpad Toggle",
    "kbacklight": "Keyboard Brightness",
    "backlight": "Screen Brightness",
    "Clipboard": "Clipboard Manager",
    "ChangeLayout": "Change Layout",
    "ChangeLayoutMenu": "Layout Menu",
}

def clean_keys(raw):
    for k, v in VAR_MAP.items():
        raw = re.sub(r"\b" + k + r"\b", v, raw)
    raw = raw.replace("..", "").replace("\"", "").replace("\x27", "").strip()
    raw = re.sub(r"\s*\+\s*", " + ", raw)
    # Visual glyphs
    raw = raw.replace("SUPER", "⌘").replace("ALT", "⌥").replace("SHIFT", "⇧").replace("CTRL", "⌃")
    raw = raw.replace("Return", "⏎").replace("Space", "␣").replace("Escape", "⎋")
    return raw

def clean_action(raw):
    for k, v in VAR_MAP.items():
        raw = re.sub(r"\b" + k + r"\b", v, raw)
    
    if "window.close" in raw: return "Close window"
    if "window.fullscreen" in raw: return "Toggle fullscreen"
    if "window.float" in raw: return "Toggle floating"
    if "window.cycle_next" in raw: return "Focus next window"
    if "window.bring_to_top" in raw: return "Bring window to top"
    if "window.drag" in raw: return "Move window (drag)"
    if "window.resize" in raw: return "Resize window"
    if "window.move" in raw: return "Move window"
    if "workspace.toggle_special" in raw:
        name = re.search(r"toggle_special\([\"\x27](.+?)[\"\x27]\)", raw)
        return f"Toggle scratchpad: {name.group(1)}" if name else "Toggle scratchpad"
    if "dsp.exit" in raw: return "Exit Hyprland"
    if "group.toggle" in raw: return "Toggle window group"
    
    m_cmd = re.search(r"exec_cmd\((.+?)\)", raw)
    if m_cmd:
        cmd = m_cmd.group(1).replace("..", "").replace("\"", "").replace("\x27", "").strip()
        cmd = re.sub(r"\s+", " ", cmd)
        return cmd
    
    m_foc = re.search(r"focus\(\{\s*workspace\s*=\s*[\"\x27](.+?)[\"\x27]\s*\}\)", raw)
    if m_foc: return f"Focus workspace {m_foc.group(1)}"
    
    m_mov = re.search(r"move_to\(\{\s*workspace\s*=\s*[\"\x27](.+?)[\"\x27]\s*\}\)", raw)
    if m_mov: return f"Move to workspace {m_mov.group(1)}"
    
    return raw

def parse_lua_keybinds(lines):
    help_content = "# ⌨️ Hyprland Keybindings\n\n"
    help_content += "| Keys | Action | Description |\n"
    help_content += "| :--- | :--- | :--- |\n"
    
    bind_count = 0
    in_divider = False

    for line in lines:
        line = line.strip()
        if not line:
            in_divider = False
            continue

        if line.startswith("-- ==="):
            in_divider = True
            continue

        if in_divider and line.startswith("-- "):
            section = line.replace("--", "").strip()
            if section and section != "Keybindings":
                help_content += f"| | **{section}** | |\n"
            in_divider = False
            continue

        in_divider = False

        if not line.startswith("hl.bind("):
            continue

        # Strip trailing comment outside quotes
        in_quote, comment_start = None, -1
        for idx in range(len(line) - 1):
            c = line[idx]
            if c in ("\"", "\x27"):
                if in_quote is None: in_quote = c
                elif in_quote == c: in_quote = None
            elif in_quote is None and line[idx:idx+2] == "--":
                comment_start = idx
                break

        comment = line[comment_start+2:].strip() if comment_start != -1 else ""
        code = line[:comment_start].strip() if comment_start != -1 else line

        m = re.search(r"^hl\.bind\((.+?),\s*(.+)\)$", code)
        if m:
            raw_keys = m.group(1).strip()
            rest = m.group(2).strip()
            opts_match = re.search(r"^(.+?),\s*(\{.*\})$", rest)
            raw_action = opts_match.group(1).strip() if opts_match else rest
            k = clean_keys(raw_keys)
            a = clean_action(raw_action)
            help_content += f"| `{k}` | {a} | {comment} |\n"
            bind_count += 1

    log(f"Parsed {bind_count} Lua bindings.")
    return help_content

def parse_conf_keybinds(lines):
    help_content = "# ⌨️ Hyprland Keybindings\n\n"
    help_content += "| Keys | Action | Description |\n"
    help_content += "| :--- | :--- | :--- |\n"

    replacements = {
        "$mainMod": "SUPER",
        "$customMod": "ALT",
        "SHIFT": "⇧",
        "CTRL": "⌃",
        "SUPER": "⌘",
        "ALT": "⌥",
        "RETURN": "⏎",
        "SPACE": "␣",
        "exec, ": "",
    }

    bind_count = 0
    for line in lines:
        line = line.strip()
        if line.startswith("###"):
            section = line.replace("#", "").strip()
            if section and section != "KEYBINDINGS":
                help_content += f"| | **{section}** | |\n"
            continue

        if line.startswith("bind") and "=" in line:
            parts = line.split("#", 1)
            bind_part = parts[0].strip()
            comment = parts[1].strip() if len(parts) > 1 else ""
            match = re.search(r'bind[deml]*\s*=\s*([^,]*),\s*([^,]+),\s*(.+)', bind_part)
            if match:
                mods = match.group(1).strip()
                key = match.group(2).strip()
                action = match.group(3).strip()
                for k, v in replacements.items():
                    mods = mods.replace(k, v)
                    key = key.replace(k, v)
                    action = action.replace(k, v)
                keys = f"{mods} + {key}" if mods else key
                help_content += f"| `{keys}` | {action} | {comment} |\n"
                bind_count += 1

    log(f"Parsed {bind_count} legacy bindings.")
    return help_content

def parse_keybinds():
    if not CONFIG_PATH:
        error_msg = f"# ❌ Error\n\nKeybinds file not found. Checked:\n" + "\n".join([f"- {p}" for p in POSSIBLE_PATHS])
        log("Error: Keybinds file not found.")
        return error_msg

    try:
        with open(CONFIG_PATH, 'r') as f:
            lines = f.readlines()
        log(f"Read {len(lines)} lines from {CONFIG_PATH}")
    except Exception as e:
        log(f"Exception reading file: {str(e)}")
        return f"# ❌ Error\n\nFailed to read {CONFIG_PATH}: {str(e)}"

    if CONFIG_PATH.endswith(".lua"):
        return parse_lua_keybinds(lines)
    else:
        return parse_conf_keybinds(lines)

if __name__ == "__main__":
    content = parse_keybinds()
    try:
        with open(OUTPUT_PATH, 'w') as f:
            f.write(content)
        log(f"Wrote help content to {OUTPUT_PATH}")
    except Exception as e:
        log(f"Exception writing output: {str(e)}")
        sys.exit(1)
