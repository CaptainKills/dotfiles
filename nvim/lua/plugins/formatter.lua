return {
	-- NOTE: Code Autoformatter
	{
		"stevearc/conform.nvim",

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

			formatters = {
				yamlfmt = {
					command = "yamlfmt",
					prepend_args = { "-conf", "yamlfmt.yml" },
				},
				["clang-format"] = {
					command = "clang-format",
					prepend_args = { "--style=file" },
				},
			},

			formatters_by_ft = {
				lua = { "stylua" },
				yaml = { "yamlfmt" },
				["yaml.ansible"] = { "yamlfmt" },
				markdown = { "mdformat" },
				java = { "clang-format" },
				c = { "clang-format" },
				json = { "clang-format" },
			},
		},
	},
}
