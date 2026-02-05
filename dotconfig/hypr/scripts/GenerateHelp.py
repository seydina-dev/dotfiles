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

# Try multiple possible locations for the config file
POSSIBLE_PATHS = [
    os.path.expanduser("~/.config/hypr/configs/Keybinds.conf"),
    os.path.expanduser("~/dotfiles/dotconfig/hypr/configs/Keybinds.conf"),
    "/home/amiral/dotfiles/dotconfig/hypr/configs/Keybinds.conf"
]

CONFIG_PATH = None
for path in POSSIBLE_PATHS:
    log(f"Checking path: {path}")
    if os.path.exists(path):
        CONFIG_PATH = path
        log(f"Found config at: {CONFIG_PATH}")
        break

OUTPUT_PATH = "/tmp/hypr_help.md"

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

    help_content = "# ⌨️ Hyprland Keybindings\n\n"
    help_content += "| Keys | Action | Description |\n"
    help_content += "| :--- | :--- | :--- |\n"

    # Common replacements for readability
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
        
        # Section headers
        if line.startswith("###"):
            section = line.replace("#", "").strip()
            if section and section != "KEYBINDINGS":
                help_content += f"| | **{section}** | |\n"
            continue

        if line.startswith("bind") and "=" in line:
            # Simple split by comment
            parts = line.split("#", 1)
            bind_part = parts[0].strip()
            comment = parts[1].strip() if len(parts) > 1 else ""
            
            # Extract bind details
            match = re.search(r'bind[deml]*\s*=\s*([^,]*),\s*([^,]+),\s*(.+)', bind_part)
            if match:
                mods = match.group(1).strip()
                key = match.group(2).strip()
                action = match.group(3).strip()
                
                # Cleanup mods and key
                for k, v in replacements.items():
                    mods = mods.replace(k, v)
                    key = key.replace(k, v)
                    action = action.replace(k, v)
                
                keys = f"{mods} + {key}" if mods else key
                help_content += f"| `{keys}` | {action} | {comment} |\n"
                bind_count += 1

    log(f"Parsed {bind_count} bindings.")
    return help_content

if __name__ == "__main__":
    content = parse_keybinds()
    try:
        with open(OUTPUT_PATH, 'w') as f:
            f.write(content)
        log(f"Wrote help content to {OUTPUT_PATH}")
    except Exception as e:
        log(f"Exception writing output: {str(e)}")
        sys.exit(1)
