-- Neovim Config: Danick Triantis

-- NOTE: [[ Vim Options ]]
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

-- NOTE: [[ Vim Keymaps ]]
vim.opt.hlsearch = true -- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "wh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "wv", "<C-w>v", { desc = "Split window vertically" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- NOTE: [[ Vim Autocommands ]]
vim.api.nvim_create_autocmd("TextYankPost", { -- Highlight when yanking (copying) text
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- NOTE: [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ import = "plugins" }, {
	change_detection = {
		enabled = true,
		notify = false,
	},
})

-- NOTE: [[ Filetype Configuration ]]
vim.filetype.add({
	extension = {},

	filename = {
		["docker-compose.yml"] = "yaml.docker-compose",
		["docker-compose.yaml"] = "yaml.docker-compose",
	},

	pattern = {},
})
