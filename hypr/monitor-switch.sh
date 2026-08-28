#!/bin/bash
# Automatic monitor configuration script for Hyprland
# This script checks which monitors are connected and configures them appropriately

# Check if external monitors are connected
HDMI_CONNECTED=$(hyprctl monitors | grep -c "HDMI-A-1")
DP_CONNECTED=$(hyprctl monitors | grep -c "DP-1")

if [ "$HDMI_CONNECTED" -gt 0 ] && [ "$DP_CONNECTED" -gt 0 ]; then
    # Both external monitors connected - disable laptop monitor
    # Layout: Husky (left) -> AOC (right)
    echo "External monitors detected - configuring dual-monitor setup (laptop disabled)"
    hyprctl keyword monitor "HDMI-A-1, 2560x1440@60, 0x0, 1"
    hyprctl keyword monitor "DP-1, 2560x1440@60, 2560x0, 1"
    hyprctl keyword monitor "eDP-1, disable"
elif [ "$HDMI_CONNECTED" -gt 0 ]; then
    # Only HDMI connected - Husky + Laptop
    echo "HDMI monitor detected - dual monitor setup"
    hyprctl keyword monitor "HDMI-A-1, 2560x1440@60, 0x0, 1"
    hyprctl keyword monitor "eDP-1, 1920x1080@60, 2560x0, 1"
elif [ "$DP_CONNECTED" -gt 0 ]; then
    # Only DP connected - AOC + Laptop
    echo "DP monitor detected - dual monitor setup"
    hyprctl keyword monitor "DP-1, 2560x1440@60, 0x0, 1"
    hyprctl keyword monitor "eDP-1, 1920x1080@60, 2560x0, 1"
else
    # No external monitors - laptop only
    echo "No external monitors detected - enabling laptop monitor only"
    hyprctl keyword monitor "eDP-1, 1920x1080@60, 0x0, 1"
    hyprctl keyword workspace "1, monitor:eDP-1, default:true"
fi
