-- Vim Options
vim.g.mapleader = " " -- Set <space> as the leader key
vim.g.maplocalleader = " " -- Set <space> as the leader key
vim.g.nerd_font = true -- Enable Nerd Font
vim.g.loaded_netrw = 1 -- Disabled Netrw for nvim-tree
vim.g.loaded_netrwplugin = 1

vim.opt.number = true -- Enable line numbers
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.showmode = false -- Show the mode
vim.opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim
vim.opt.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.inccommand = "split" -- Preview substitutions live
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor
vim.opt.signcolumn = "yes" -- Keep git signcolumn on by default
vim.opt.laststatus = 3 -- Global statusline

-- Set width of tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Setup code folding
vim.opt.fillchars = [[fold: ,foldopen:,foldsep: ,foldclose:]]
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- Filetype Configuration
vim.filetype.add({
	extension = {
		h = "c",
		c = "c",
		hpp = "cpp",
		cpp = "cpp",
	},

	filename = {
		["docker-compose.yml"] = "yaml.docker-compose",
		["docker-compose.yaml"] = "yaml.docker-compose",
	},

	pattern = {},
})
