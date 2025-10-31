return {
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
				virt_text_pos = "right_align",
			},
			attach_to_untracked = true,
		},

		config = function(_, opts)
			local gitsigns = require("gitsigns")
			gitsigns.setup(opts)

			-- NOTE: Normal Mode
			vim.keymap.set("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git: stage hunk" })
			vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git: reset hunk" })

			vim.keymap.set("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git: stage buffer" })
			vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git: reset buffer" })

			vim.keymap.set("n", "<leader>hd", gitsigns.diffthis, { desc = "Git: diff this" })
			vim.keymap.set("n", "<leader>hb", gitsigns.toggle_current_line_blame, { desc = "Git: toggle blame" })

			-- NOTE: Visual Mode
			vim.keymap.set("v", "<leader>hs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Git: stage hunk (visual)" })

			vim.keymap.set("v", "<leader>hr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "Git: reset hunk (visual)" })

			-- NOTE: Navigation
			vim.keymap.set("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Git: navigate to next hunk" })

			vim.keymap.set("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Git: navigate to previous hunk" })
		end,
	},
}
