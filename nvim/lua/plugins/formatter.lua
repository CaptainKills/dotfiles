return {
	-- NOTE: Code Autoformatter
	{
		"stevearc/conform.nvim",
		ft = require("core.config").formatter.ft,

		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},

		opts = {
			notify_on_error = true,

			format_on_save = function(bufnr)
				return {
					timeout_ms = 500,
					lsp_fallback = true,
				}
			end,

			formatters = require("core.config").formatter.formatters,
			formatters_by_ft = require("core.config").formatter.formatters_by_ft,
		},
	},
}
