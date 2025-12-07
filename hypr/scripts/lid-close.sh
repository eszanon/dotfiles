#!/bin/bash

# Check if there are any external monitors connected
external_monitors=$(hyprctl monitors -j | jq '[.[] | select(.name != "eDP-1")] | length')

# Only proceed if there's at least one external monitor
if [ "$external_monitors" -gt 0 ]; then
    # Switch to workspace 1 if currently on workspace 3
    current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')
    if [ "$current_workspace" = "3" ]; then
        hyprctl dispatch workspace 1
    fi

    # Move all windows from workspace 3 to workspace 1 (this will close workspace 3)
    for window in $(hyprctl clients -j | jq -r '.[] | select(.workspace.id == 3) | .address'); do
        hyprctl dispatch movetoworkspace 1,address:$window
    done

    # Disable the laptop monitor
    hyprctl keyword monitor "eDP-1, disable"
else
    # No external monitor - just suspend/lock instead of disabling the display
    # You can customize this behavior (e.g., systemctl suspend, or do nothing)
    echo "No external monitor detected, skipping monitor disable"
    systemctl suspend
fi
