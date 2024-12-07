-- Vim Keymaps: C
vim.keymap.set("n", "<C-S>", ":ClangdSwitchSourceHeader<CR>", { desc = "C: Toggle between source and header file" })
vim.keymap.set("n", "<C-I>", ":ClangdShowSymbolInfo<CR>", { desc = "C: Show symbol info" })
