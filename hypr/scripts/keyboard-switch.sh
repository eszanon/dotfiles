#!/bin/bash
# Automatic keyboard layout script for Hyprland
# This script checks if external keyboards are connected and sets the layout accordingly

# List all keyboard devices (excluding virtual/built-in devices)
# The laptop keyboard is "at-translated-set-2-keyboard"
# Filter out all virtual devices and the built-in laptop keyboard
EXTERNAL_KB=$(hyprctl devices -j | jq -r '.keyboards[] | select(.name | test("power-button|video-bus|sleep-button|intel-hid|dell-wmi|at-translated-set-2-keyboard"; "i") | not) | .name' | wc -l)

if [ "$EXTERNAL_KB" -gt 0 ]; then
    # External keyboard connected - use br,us layout
    echo "External keyboard detected - setting layout to br,us"
    hyprctl keyword input:kb_layout "br,us"
else
    # No external keyboard - laptop only, use us layout
    echo "No external keyboard detected - setting layout to us"
    hyprctl keyword input:kb_layout "us"
fi
