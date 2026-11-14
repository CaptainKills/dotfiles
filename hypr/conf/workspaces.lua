-- INFO: Workspace Rules

local monitor_main = "eDP-1"
local monitor_extended = "desc:Dell Inc. DELL P2418D MY3ND0120JTT"

hl.workspace_rule({ workspace = "1", monitor = monitor_main, default = true })
hl.workspace_rule({ workspace = "2", monitor = monitor_main })
hl.workspace_rule({ workspace = "3", monitor = monitor_main })
hl.workspace_rule({ workspace = "4", monitor = monitor_main })
hl.workspace_rule({ workspace = "5", monitor = monitor_main })
hl.workspace_rule({ workspace = "6", monitor = monitor_extended, default = true })
hl.workspace_rule({ workspace = "7", monitor = monitor_extended })
hl.workspace_rule({ workspace = "8", monitor = monitor_extended })
hl.workspace_rule({ workspace = "9", monitor = monitor_extended })
hl.workspace_rule({ workspace = "10", monitor = monitor_extended })

-- INFO: Window Rules

hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

-- Application Window Rules
hl.window_rule({
	name = "discord-workspace",
	match = { title = ".*Discord.*" },
	workspace = "3",
})

hl.window_rule({
	name = "spotify-workspace",
	match = { title = ".*Spotify.*" },
	workspace = "2",
})

hl.window_rule({
	name = "whatsapp-workspace",
	match = { title = ".*Untitled.*" },
	workspace = "1",
})
