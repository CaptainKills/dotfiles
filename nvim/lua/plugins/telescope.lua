return {
	"nvim-telescope/telescope.nvim",
	tag = "v0.2.0",

	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",

			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-tree/nvim-web-devicons" },
	},

	opts = {
		pickers = {
			find_files = {
				find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "--glob", "!.gitattributes" },
				follow = true,
			},
		},
	},

	config = function(_, opts)
		require("telescope").setup(opts)

		-- NOTE: Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")

		-- NOTE: Telescope Keymaps
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
		vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
		vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
		vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
		vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files ('.' for repeat)" })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
		vim.keymap.set("n", "<leader>st", ":TodoTelescope<CR>", { desc = "[S]earch [T]odo comments" })

		-- NOTE: Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })

		-- NOTE: Telescope Git Keymaps
		vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Search [G]it [S]tatus" })
		vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Search [G]it [C]ommits" })
		vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Search [G]it [B]ranches" })
	end,
}
