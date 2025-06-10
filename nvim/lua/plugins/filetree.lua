return {
	-- NOTE: Nvim Tree
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },

		opts = {},

		config = function()
			local tree = require("nvim-tree")

			tree.setup({
				hijack_cursor = true,
				sync_root_with_cwd = true,
				sort = {
					sorter = "case_sensitive",
				},
				view = {
					width = {}, -- Automically adjust width to longest line in filetree
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = false,
				},
				git = {
					enable = false,
				},
			})

			-- NOTE: File Explorer Keymaps
			vim.keymap.set("n", "<leader>to", ":NvimTreeOpen<CR>", { desc = "[T]oggle Filetree [O]pen" })
			vim.keymap.set("n", "<leader>tc", ":NvimTreeClose<CR>", { desc = "[T]oggle Filetree [C]losed" })
			vim.keymap.set("n", "<leader>tr", ":NvimTreeRefresh<CR>", { desc = "File[T]ree [R]efresh" })
		end,
	},
}
