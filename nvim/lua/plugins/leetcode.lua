return {
	{
		"kawre/leetcode.nvim",
		cmd = "Leet",

		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			lang = "golang",
			picker = { provider = "telescope" },
			storage = {
				home = "/home/danick/leetcode/",
				cache = "/home/danick/leetcode/.cache",
			},

			editor = {
				reset_previous_code = false,
				fold_imports = false,
			},

			injector = {
				["golang"] = {
					imports = function(default_imports)
						vim.list_extend(default_imports, { "package main" })
						return default_imports
					end,
					after = "func main(){\n}",
				},
			},
		},
	},
}
