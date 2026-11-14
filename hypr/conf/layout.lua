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

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "dwindle",
	},

	-- INFO: Variables - Decoration
	decoration = {
		rounding = 10,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		-- https://wiki.hypr.land/Configuring/Variables/#blur
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
		preserve_split = true, -- You probably want this
	},

	-- INFO: Master Layout
	master = {
		new_status = "master",
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
