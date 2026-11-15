#!/bin/bash

# --- CONFIGURATION ---
CONFIG_FILE="/home/danick/.config/hypr/conf/workspaces.lua"
QUERY="local active = Monitors.HOME"
# ---------------------

if cat "$CONFIG_FILE" | grep -q "$QUERY"; then
	# Replace HOME with OFFICE
	original="Monitors.HOME"
	replacement="Monitors.OFFICE"
else
	# Replace OFFICE with HOME
	original="Monitors.OFFICE"
	replacement="Monitors.HOME"
fi

# Replace Monitors
sed -i "s/$original/$replacement/" "$CONFIG_FILE"
hyprctl reload
