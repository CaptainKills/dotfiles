-- Vim Keymaps: C
vim.keymap.set("n", "<C-s>", ":LspClangdSwitchSourceHeader<CR>", { desc = "C: Toggle between source and header file" })
vim.keymap.set("n", "<C-i>", ":LspClangdShowSymbolInfo<CR>", { desc = "C: Show symbol info" })
