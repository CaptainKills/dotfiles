#!/bin/bash

# --- CONFIGURATION ---
CONFIG_FILE="/home/danick/.config/hypr/conf/workspaces.lua"
QUERY="local active = Monitors.HOME"
# ---------------------

# Output JSON status for Waybar
output_status() {
	local status=$1

	# Waybar JSON format: {"text": "", "alt": "status", "class": "status", "tooltip": "..."}
	echo "{\"text\":\"${status}\",\"alt\":\"\",\"class\":\"${status}\",\"tooltip\":\"\"}"
}

# Check which displays are currently active
if cat "$CONFIG_FILE" | grep -q "$QUERY"; then
	output_status "Home"
else
	output_status "Office"
fi
