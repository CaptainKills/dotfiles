#!/bin/bash

# --- CONFIGURATION ---
CONFIG_FILE="/home/danick/.config/hypr/conf/workspaces.lua"

HOME_MAIN="eDP-1"
HOME_EXTENDED="desc:Dell Inc. DELL P2418D MY3ND0120JTT"

OFFICE_MAIN=""
OFFICE_EXTENDED=""
# ---------------------

# Setup helper variables
base_main="local monitor_main ="
base_extended="local monitor_extended ="
query="$base_main \"$HOME_MAIN\""

if cat "$CONFIG_FILE" | grep -q "$query"; then
	# Replace HOME with OFFICE
	original_main="$base_main \"$HOME_MAIN\""
	replacement_main="$base_main \"$OFFICE_MAIN\""

	original_extended="$base_extended \"$HOME_EXTENDED\""
	replacement_extended="$base_extended \"$OFFICE_EXTENDED\""
else
	# Replace OFFICE with HOME
	original_main="$base_main \"$OFFICE_MAIN\""
	replacement_main="$base_main \"$HOME_MAIN\""

	original_extended="$base_extended \"$OFFICE_EXTENDED\""
	replacement_extended="$base_extended \"$HOME_EXTENDED\""
fi

# Replace Monitors
sed -i "s/$original_main/$replacement_main/" "$CONFIG_FILE"
sed -i "s/$original_extended/$replacement_extended/" "$CONFIG_FILE"
hyprctl reload
