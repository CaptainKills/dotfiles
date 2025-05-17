return {
	-- NOTE: Autocomplete
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",

		version = "v1.*",
		opts = {
			keymap = { preset = "default" },

			appearance = {
				use_nvim_cmp_as_default = true,
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
