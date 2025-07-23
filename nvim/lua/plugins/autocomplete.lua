return {
	-- NOTE: Autocomplete
	{
		"saghen/blink.cmp",

		version = "v1.*",
		opts = {
			keymap = { preset = "default" },

			appearance = {
				nerd_font_variant = "mono",
			},

			signature = { enabled = true },
		},
	},

	-- NOTE: Closing Brackets Automatically
	{
		"m4xshen/autoclose.nvim",
		opts = {},
	},
}
