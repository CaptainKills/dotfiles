return {
	-- NOTE: Code Autoformatter
	{
		"stevearc/conform.nvim",

		opts = {
			notify_on_error = false,

			format_on_save = function(bufnr)
				return {
					timeout_ms = 500,
					lsp_fallback = true,
				}
			end,

			formatters = require("core.config").formatter.formatters,
			formatters_by_ft = require("core.config").formatter.formatters_by_ft,
		},

		config = function(_, opts)
			local conform = require("conform")
			conform.setup(opts)

			vim.keymap.set("n", "<leader>f", function()
				conform.format({ async = true, lsp_fallback = true })
			end, { desc = "[F]ormat buffer" })
		end,
	},
}
