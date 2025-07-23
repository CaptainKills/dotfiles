return {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },

	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
				autoImportCompletions = true,
				typeCheckingMode = "standard",
			},
			pythonPath = "python3",
		},
	},
}
