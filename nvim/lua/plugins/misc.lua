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
			current_line_blame_opts = {
				delay = 0,
			},
		},

		config = function(_, opts)
			local gitsigns = require("gitsigns")
			gitsigns.setup(opts)

			vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git: stage hunk" })
			vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git: reset hunk" })

			vim.keymap.set("v", "<leader>hs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Git: stage hunk (visual)" })

			vim.keymap.set("v", "<leader>hr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Git: reset hunk (visual)" })

			vim.keymap.set("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git: stage buffer" })
			vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git: reset buffer" })

			vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, { desc = "Git: diff this" })
			vim.keymap.set("n", "<leader>hb", gitsigns.toggle_current_line_blame, { desc = "Git: toggle blame" })
		end,
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
		config = function() end,
	},

	-- NOTE: Typst Preview
	{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		version = "1.*",
		opts = {
			invert_colors = "auto",

			dependencies_bin = {
				["tinymist"] = "tinymist",
			},
		},
	},
}
