return {
	{
		-- "folke/tokyonight.nvim",
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,

		init = function()
			-- vim.cmd.colorscheme("tokyonight-night")
			vim.cmd.colorscheme("catppuccin-macchiato")
		end,
	},
}
