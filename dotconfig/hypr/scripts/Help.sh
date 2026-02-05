#!/bin/bash
# Antigravity Robust Help Script

# 1. Setup absolute paths for binaries
PYTHON="/usr/bin/python3"
KITTY="/usr/bin/kitty"
BAT="/usr/bin/bat"
NOTIFY="/usr/bin/notify-send"

# 2. Setup script locations
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GENERATOR="$SCRIPT_DIR/GenerateHelp.py"
OUTPUT="/tmp/hypr_help.md"

# 3. Run the generator
$PYTHON "$GENERATOR" &> /tmp/hypr_help_run.log

# 4. Choose viewer
if [ -x "$BAT" ]; then
    VIEWER="$BAT --paging=always --style=plain --language=markdown"
else
    VIEWER="less"
fi

# 5. Launch in terminal with a safety pause
if [ -f "$OUTPUT" ]; then
    # We use a shell wrapper inside kitty to ensure the window doesn't close 
    # if the pager fails or exits unexpectedly.
    $KITTY --title "⌨️ Hyprland Help" -e /usr/bin/sh -c "
        $VIEWER $OUTPUT || cat $OUTPUT;
        echo;
        echo '----------------------------------------';
        echo ' Press any key to close this window... ';
        read -n 1 -s -r
    "
else
    # Fallback if generation failed
    $NOTIFY "Help Error" "Failed to generate $OUTPUT. See /tmp/hypr_help_run.log"
    $KITTY --title "Help Error" -e /usr/bin/sh -c "
        echo 'ERROR: Help generation failed.';
        echo 'Check /tmp/hypr_help_run.log for details.';
        echo;
        if [ -f /tmp/hypr_help_debug.log ]; then
            echo '--- Debug Log ---';
            cat /tmp/hypr_help_debug.log;
        fi;
        read -n 1 -s -r -p 'Press any key to close...'
    "
fi
