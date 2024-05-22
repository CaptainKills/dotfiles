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
				"marksman",

				-- (2) DAP

				-- (3) Linter
				"ansible-lint",
				"yamllint",

				-- (4) Formatter
				"stylua",
				"yamlfix",
				"mdformat",
			},
		},
	},
}
