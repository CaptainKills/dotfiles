return {
	{
		"stevearc/oil.nvim",
		keys = { "<leader>e" },
		dependencies = { "nvim-tree/nvim-web-devicons" },

		opts = {
			constrain_cursor = "name",

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

			vim.keymap.set("n", "<leader>e", oil.open, { desc = "Oil: Open working directory" })
		end,
	},
}
