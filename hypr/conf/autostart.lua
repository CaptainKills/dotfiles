-- INFO: Autostart

hl.on("hyprland.start", function()
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("hypridle")
	hl.exec_cmd("hyprsunset")

	hl.exec_cmd("waybar")
	hl.exec_cmd("swaync")
end)
