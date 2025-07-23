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

	-- NOTE: Language Server Protocol Diagnostics
	{
		"rachartier/tiny-inline-diagnostic.nvim",

		opts = {
			preset = "classic",

			signs = {},
			blend = {
				factor = 0.1,
			},

			options = {
				overflow = {
					padding = 5,
				},
			},
		},

		config = function(_, opts)
			require("tiny-inline-diagnostic").setup(opts)
		end,
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

	-- NOTE: Go Debug Adapter
	{
		"leoluz/nvim-dap-go",
		ft = "go",
	},
}
