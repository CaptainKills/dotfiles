-- Vim Local Options:
vim.cmd([[
	setlocal textwidth=100
	setlocal formatoptions+=t
	setlocal linebreak
]])

-- Format Paragraph Keymap
vim.keymap.set("n", "gq", "vipgq", { desc = "Format paragraph according with formatexpr" })
vim.keymap.set("n", "gw", "vipgw", { desc = "Format paragraph according without formatexpr" })
