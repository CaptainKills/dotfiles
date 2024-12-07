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
			ensure_installed = require("core.config").mason.ensure_installed,
			auto_update = true,
			run_on_start = true,
			start_delay = 3000,
		},
	},
}
