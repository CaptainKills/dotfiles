return {
	-- NOTE: Autocomplete
	{
		"saghen/blink.cmp",
		dependencies = { "L3MON4D3/LuaSnip" },

		version = "v1.*",
		opts = {
			keymap = {
				preset = "default",
				["<C-p>"] = { "select_prev", "snippet_backward", "fallback_to_mappings" },
				["<C-n>"] = { "select_next", "snippet_forward", "fallback_to_mappings" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			signature = { enabled = true },
			snippets = { preset = "luasnip" },
		},
	},

	-- NOTE: Closing Brackets Automatically
	{
		"m4xshen/autoclose.nvim",
		opts = {},
	},
}
