#!/bin/bash
# Re-enable the laptop monitor
hyprctl keyword monitor "eDP-1, 1920x1080@60, 5120x0, 1"

# Reassign workspace 3 to the laptop monitor
hyprctl keyword workspace "3, monitor:eDP-1, default:true"
