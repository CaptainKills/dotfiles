hl.config({
	-- INFO: Variables - General
	general = {
		gaps_in = 5,
		gaps_out = 5,

		border_size = 2,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		resize_on_border = false,
		allow_tearing = false,

		layout = "dwindle",
	},

	-- INFO: Variables - Decoration
	decoration = {
		rounding = 10,
		rounding_power = 2,

		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	-- INFO: Variables - Animations
	animations = {
		enabled = true,
	},

	-- INFO: Window Layout
	dwindle = {
		force_split = 2,
		preserve_split = true,
	},

	-- INFO: Misc
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
	},

	-- INFO: XWayland
	xwayland = {
		force_zero_scaling = true,
	},
})
