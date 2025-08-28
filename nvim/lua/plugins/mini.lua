return {
	"nvim-mini/mini.nvim",
	version = false,

	config = function()
		-- NOTE: Better Around / Inside Textobjects
		local ai = require("mini.ai")
		ai.setup({ n_lines = 500 })

		-- NOTE: Add / Delete / Replace Surroundings
		local surround = require("mini.surround")
		surround.setup({})

		-- NOTE: Status Line
		local statusline = require("mini.statusline")
		statusline.setup({ use_icons = vim.g.have_nerd_font })
		statusline.section_location = function()
			return "%2l:%-2v"
		end
	end,
}
