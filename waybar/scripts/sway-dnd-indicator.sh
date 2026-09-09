#!/bin/bash
# Waybar indicator: visible only while mako is in do-not-disturb mode.
# Refreshed by SIGRTMIN+10 from sway/bin/toggle-notifications.
if makoctl mode 2>/dev/null | grep -q do-not-disturb; then
  echo '{"text": "󰂛", "class": "active", "tooltip": "Notifications silenced  ·  Super+Ctrl+, to enable"}'
else
  echo '{"text": "", "tooltip": "Notifications on"}'
fi
