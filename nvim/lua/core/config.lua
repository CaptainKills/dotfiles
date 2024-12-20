local M = {}

-- NOTE: DAP Configuration
M.dap = {
	-- The filetype(s) for which this plugin is enabled.
	-- ft = {},

	-- DAP Adapter Configurations
	adapters = {
		codelldb = {
			type = "server",
			host = "127.0.0.1",
			port = "3000",
			executable = {
				command = "codelldb",
				args = { "--port", "3000" },
			},
		},
	},

	-- DAP Filetype Configurations
	configurations = {
		java = {
			{
				name = "Debug Application",
				type = "java",
				request = "launch",
			},
		},

		c = {
			{
				name = "Debug Application",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
			},
		},
	},
}

-- NOTE: Formatter Configuration
M.formatter = {
	-- The filetype(s) for which this plugin is enabled.
	ft = {},

	-- Formatter Configurations
	formatters = {
		yamlfmt = {
			command = "yamlfmt",
			prepend_args = { "-conf", "yamlfmt.yml" },
		},

		["clang-format"] = {
			command = "clang-format",
			prepend_args = { "--style=file" },
		},

		gofumpt = {
			command = "gofumpt",
			-- prepend_args = {},
		},

		["goimports-reviser"] = {
			command = "goimports-reviser",
			-- prepend_args = { "-rm-unused" },
		},

		golines = {
			command = "golines",
			prepend_args = { "-m", "120" },
		},

		black = {
			command = "black",
			prepend_args = { "--config", "pyproject.toml" },
		},
	},

	-- Formatter Filetype Configurations
	formatters_by_ft = {
		lua = { "stylua" },
		java = { "clang-format" },
		c = { "clang-format" },
		go = { "gofumpt", "goimports-reviser", "golines" },
		python = { "black" },
		yaml = { "yamlfmt" },
		["yaml.ansible"] = { "yamlfmt" },
		markdown = { "mdformat" },
		json = { "clang-format" },
	},
}

-- NOTE: Linter Configuration
M.linter = {
	-- The filetype(s) for which this plugin is enabled.
	-- ft = {},

	-- Linter Filetype Configurations
	linter_by_ft = {
		python = { "mypy", "ruff" },
	},
}

-- NOTE: LSP Configuration
M.lsp = {
	-- The filetype(s) for which this plugin is enabled.
	-- ft = {},

	-- LSP Configurations
	configurations = {
		lua_ls = {
			cmd = { "lua-language-server" },
			filetype = { "lua" },
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					workspace = {
						checkThirdParty = false,
						library = {
							"${3rd}/luv/library",
							unpack(vim.api.nvim_get_runtime_file("", true)),
						},
					},
					completion = {
						callSnippet = "Replace",
					},
					hint = {
						enable = true,
					},
				},
			},
		},

		clangd = {
			cmd = { "clangd" },
			filetype = { "c", "cpp" },
		},

		gopls = {
			cmd = { "gopls" },
			filetype = { "go", "gomod", "gowork", "gotmpl" },
			settings = {
				gopls = {
					gofumpt = true,
				},
			},
		},

		pyright = {
			cmd = { "pyright-langserver", "--stdio" },
			filetype = { "python" },
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
		},

		ansiblels = {
			cmd = { "ansible-language-server", "--stdio" },
			filetype = { "yaml.ansible" },
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
		},

		docker_compose_language_service = {
			cmd = { "docker-compose-langserver", "--stdio" },
			filetype = { "yaml.docker-compose" },
		},
	},
}

-- NOTE: Mason Configuration
M.mason = {
	-- The filetype(s) for which this plugin is enabled.
	-- ft = {},

	-- Ensure the following packages are installed.
	ensure_installed = {
		-- Lua
		"lua_ls", -- LSP
		"stylua", -- Formatter

		-- Java
		"jdtls", -- LSP
		"java-debug-adapter", -- DAP
		"java-test", -- DAP

		-- C
		"clangd", -- LSP
		"codelldb", -- DAP
		"clang-format", -- Formatter

		-- Go
		"gopls", -- LSP
		"gofumpt", -- Formatter
		"goimports-reviser", -- Formatter
		"delve", -- DAP

		-- Python
		"pyright", -- LSP
		"mypy", -- Linter
		"ruff", -- Linter
		"black", -- Formatter

		-- Ansible
		"ansiblels", -- LSP
		"ansible-lint", -- Linter
		"yamlfmt", -- Formatter

		-- Docker Compose
		"docker_compose_language_service", -- LSP

		-- Markdown
		"mdformat", -- Formatter
	},
}

return M
