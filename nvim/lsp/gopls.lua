return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork" },
	root_markers = { "go.mod" },

	settings = {
		gopls = {
			gofumpt = true,
		},
	},
}
