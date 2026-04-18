return {
	-- NOTE: Detect tabstop and shiftwidth automatically
	{
		"NMAC427/guess-indent.nvim",
		opts = {},
	},

	-- NOTE: Autocomment via "gc", "gcc", "gbc", "gcO", "gco", "gca"
	{
		"numToStr/Comment.nvim",
		opts = {},
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

	-- NOTE: Language Server Protocol Notifications
	{
		"j-hui/fidget.nvim",
		opts = {
			progress = {
				suppress_on_insert = true,
			},
		},
	},

	-- NOTE: Ansible Neovim
	{
		"mfussenegger/nvim-ansible",
		ft = { "yaml", "yaml.ansible" },
		config = function() end,
	},

	-- NOTE: Typst Preview
	{
		"chomosuke/typst-preview.nvim",
		ft = { "typst" },
		version = "1.*",
		opts = {
			invert_colors = "auto",

			dependencies_bin = {
				["tinymist"] = "tinymist",
			},
		},
	},

	-- NOTE: LTeX Extra (Dictionary/Rules)
	{
		"barreiroleo/ltex_extra.nvim",
		ft = { "markdown", "typst" },
		branch = "dev",
		opts = {
			load_langs = { "en-GB" },
			path = ".ltex",
		},
	},

	-- NOTE: Markdown Renderer
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown" },
	},
}
