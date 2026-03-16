#!/bin/bash

# Volume control script for Waybar that handles both PulseAudio and PipeWire
# and works correctly with Bluetooth devices

# Check which audio system is running
if command -v wpctl &> /dev/null; then
    # Use wpctl for PipeWire (better Bluetooth support)
    if [ "$1" = "up" ]; then
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01+
    elif [ "$1" = "down" ]; then
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.01-
    else
        exit 1
    fi
else
    # Fall back to pactl for PulseAudio
    if [ "$1" = "up" ]; then
        pactl set-sink-volume @DEFAULT_SINK@ +1%
    elif [ "$1" = "down" ]; then
        pactl set-sink-volume @DEFAULT_SINK@ -1%
    else
        exit 1
    fi
fi
