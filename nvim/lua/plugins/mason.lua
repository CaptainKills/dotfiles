return {
	-- NOTE: Mason Package Manager
	{
		"williamboman/mason.nvim",

		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},

	-- NOTE: Mason Installer
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },

		opts = {
			ensure_installed = {
				-- (1) LSP
				"lua_ls",
				"ansiblels",
				"yamlls",
				"docker_compose_language_service",
				"jdtls",
				"pyright",
				"clangd",

				-- (2) DAP
				"java-debug-adapter",
				"java-test",
				"codelldb",

				-- (3) Linter
				"ansible-lint",
				"mypy",
				"ruff",

				-- (4) Formatter
				"stylua",
				"yamlfmt",
				"mdformat",
				"clang-format",
				"black",
			},

			auto_update = true,
			run_on_start = true,
			start_delay = 3000,
		},
	},
}
