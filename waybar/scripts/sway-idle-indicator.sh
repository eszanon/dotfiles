#!/bin/bash
# Waybar indicator: visible only while idle locking is OFF (swayidle not running).
# Refreshed by SIGRTMIN+9 from sway/bin/toggle-idle.
if pgrep -x swayidle >/dev/null; then
  echo '{"text": "", "tooltip": "Idle lock on  ·  Super+Ctrl+I to disable"}'
else
  echo '{"text": "󰅶", "class": "active", "tooltip": "Idle lock OFF  ·  Super+Ctrl+I to enable"}'
fi
