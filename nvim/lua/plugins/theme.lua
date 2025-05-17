return {
	"folke/tokyonight.nvim",
	priority = 1000,

	init = function()
		require("tokyonight").setup({
			on_colors = function(colors)
				colors.border = colors.fg_dark
			end
		})
		vim.cmd.colorscheme("tokyonight-night")
	end,
}
