local M = {}

-- NOTE: Mason Configuration
M.mason = {
	-- Ensure the following packages are installed.
	ensure_installed = {
		-- Lua
		"lua-language-server", -- LSP
		"stylua", -- Formatter

		-- Bash
		"bash-language-server", -- LSP
		"shfmt", -- Formatter

		-- C
		"clangd", -- LSP
		"clang-format", -- Formatter
		"codelldb", -- DAP

		-- Go
		"gopls", -- LSP
		"gofumpt", -- Formatter
		"goimports-reviser", -- Formatter
		"delve", -- DAP

		-- Rust
		-- "rust-analyzer", -- LSP
		-- "rustfmt", -- Formatter

		-- Python
		"pyright", -- LSP
		"ruff", -- Formatter

		-- Ansible
		"ansible-language-server", -- LSP
		"ansible-lint", -- Linter
		"yamlfmt", -- Formatter

		-- Docker Compose
		"docker-compose-language-service", -- LSP

		-- Typst
		"tinymist", -- LSP
		"typstyle", -- Formatter
		"ltex-ls-plus", -- Spellchecker
	},
}

-- NOTE: LSP Configuration
M.lsp = {
	-- Lua
	"lua_ls",

	-- Bash
	"bashls",

	-- C
	"clangd",

	-- Go
	"gopls",

	-- Rust
	"rust_analyzer",

	-- Python
	"pyright",

	-- Ansible
	"ansiblels",

	-- Docker Compose
	"docker_ls",

	-- Typst
	"tinymist",
	"ltex_plus",
}

-- NOTE: Formatter Configuration
M.formatter = {
	-- Formatter Configurations
	formatters = {
		-- C
		["clang-format"] = {
			command = "clang-format",
			prepend_args = { "--style=file" },
		},

		-- Yaml & Ansible & Docker Compose
		yamlfmt = {
			command = "yamlfmt",
			prepend_args = { "-conf", "yamlfmt.yml" },
		},
	},

	-- Formatter Filetype Configurations
	formatters_by_ft = {
		lua = { "stylua" },

		sh = { "shfmt" },

		c = { "clang-format" },
		cpp = { "clang-format" },
		cuda = { "clang-format" },
		json = { "clang-format" },

		go = { "gofumpt", "goimports-reviser" },

		rust = { "rustfmt" },

		python = { "ruff_format" },

		yaml = { "yamlfmt" },
		["yaml.ansible"] = { "yamlfmt" },
		["yaml.docker-compose"] = { "yamlfmt" },

		typst = { "typstyle" },
	},
}

return M
