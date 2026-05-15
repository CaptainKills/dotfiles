#!/bin/bash
set -eEo pipefail

# --- CONFIGURATION ---
CONNECTION_NAME="VPN Eindhoven"
# ---------------------

# Output JSON status for Waybar
output_status() {
	local status=$1
	local tooltip=$2
	# Waybar JSON format: {"text": "", "alt": "status", "class": "status", "tooltip": "..."}
	echo "{\"text\":\"\",\"alt\":\"${status}\",\"class\":\"${status}\",\"tooltip\":\"${tooltip}\"}"
}

# Check if the NetworkManager connection is active
if nmcli connection show --active | grep -q "${CONNECTION_NAME}"; then
	output_status "connected" "Connected: ${CONNECTION_NAME}"
else
	output_status "disconnected" "Disconnected: ${CONNECTION_NAME}"
fi
