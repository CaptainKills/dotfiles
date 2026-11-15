-- INFO: Workspace Rules

local Monitors = {
	HOME = {
		main = "eDP-1",
		extended = "desc:Dell Inc. DELL P2418D MY3ND0120JTT",
	},

	OFFICE = {
		main = "",
		extended = "",
	},
}

local active = Monitors.HOME

hl.workspace_rule({ workspace = "1", monitor = active.main, default = true })
hl.workspace_rule({ workspace = "2", monitor = active.main })
hl.workspace_rule({ workspace = "3", monitor = active.main })
hl.workspace_rule({ workspace = "4", monitor = active.main })
hl.workspace_rule({ workspace = "5", monitor = active.main })
hl.workspace_rule({ workspace = "6", monitor = active.extended, default = true })
hl.workspace_rule({ workspace = "7", monitor = active.extended })
hl.workspace_rule({ workspace = "8", monitor = active.extended })
hl.workspace_rule({ workspace = "9", monitor = active.extended })
hl.workspace_rule({ workspace = "10", monitor = active.extended })

-- INFO: Window Rules

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
	match = { title = ".*WhatsApp.*" },
	workspace = "1",
})

-- Hyprland Window Rules
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

hl.window_rule({
	-- Hyprland-run windowrule
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})
