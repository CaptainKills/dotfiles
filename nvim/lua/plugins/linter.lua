return {
	-- NOTE: Neovim Linter
	{
		"mfussenegger/nvim-lint",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"williamboman/mason-tool-installer.nvim",
		},

		opts = {},

		config = function()
			local lint = require("lint")

			lint.linters_by_ft = require("core.config").linter.linter_by_ft

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					require("lint").try_lint()
				end,
			})
		end,
	},
}
