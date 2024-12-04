return {
	-- NOTE: Detect tabstop and shiftwidth automatically
	{
		"tpope/vim-sleuth",
		config = function() end,
	},

	-- NOTE: Autocomment via "gc", "gcc", "gbc", "gcO", "gco", "gca"
	{
		"numToStr/Comment.nvim",
		opts = {},
	},

	-- NOTE: Git signs to gutter
	{
		"lewis6991/gitsigns.nvim",

		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- NOTE: Highlight todo, notes, etc in comments
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	-- NOTE: Ansible Neovim
	{
		"mfussenegger/nvim-ansible",
		config = function() end,
	},

	-- NOTE: Java Language Server
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
	},

	-- NOTE: Closing Brackets Automatically
	{
		"rstacruz/vim-closer",
		config = function() end,
	},

	-- NOTE: Closing Structures Automatically
	{
		"tpope/vim-endwise",
		config = function() end,
	},
}
