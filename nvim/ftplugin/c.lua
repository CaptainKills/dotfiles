-- Vim Keymaps: C
vim.keymap.set("n", "<C-s>", ":ClangdSwitchSourceHeader<CR>", { desc = "C: Toggle between source and header file" })
vim.keymap.set("n", "<C-i>", ":ClangdShowSymbolInfo<CR>", { desc = "C: Show symbol info" })
