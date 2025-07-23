return {
	cmd = { "ansible-language-server", "--stdio" },
	filetypes = { "yaml.ansible" },

	settings = {
		ansible = {
			ansible = {
				path = "ansible",
			},
			executionEnvironment = {
				enabled = false,
			},
			python = {
				path = "python3",
			},
			validation = {
				enabled = true,
				lint = {
					enabled = true,
					path = "ansible-lint",
				},
			},
		},
	},
}
