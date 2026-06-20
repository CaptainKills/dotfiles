return {
	{
		"stevearc/oil.nvim",
		keys = { "<leader>e" },
		dependencies = { "nvim-tree/nvim-web-devicons" },

		opts = {
			constrain_cursor = "name",

			float = {
				max_width = 0.75,
				max_height = 0.75,
				preview_split = "right",
			},

			view_options = {
				show_hidden = true,

				is_always_hidden = function(name, bufnr)
					return name == ".git"
				end,
			},
		},

		config = function(_, opts)
			local oil = require("oil")
			oil.setup(opts)

			vim.keymap.set("n", "<leader>e", function()
				oil.toggle_float(nil, { preview = {} })
			end, { desc = "Oil: Open working directory" })
		end,
	},
}
