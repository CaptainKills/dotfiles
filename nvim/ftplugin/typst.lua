-- INFO: LSP: General Keymaps
vim.keymap.set("n", "<leader>li", ":LspTinymistGetServerInfo<CR>", { desc = "Typst: Get LSP Info" })
vim.keymap.set("n", "<leader>ld", ":LspTinymistGetDocumentMetrics<CR>", { desc = "Typst: Get Document Metrics" })
vim.keymap.set("n", "<leader>lw", ":LspTinymistGetWorkspaceLabels<CR>", { desc = "Typst: Get Workspace Labels" })
vim.keymap.set("n", "<leader>lt", ":LspTinymistGetDocumentTrace<CR>", { desc = "Typst: Get Document Trace" })

-- INFO: LSP: Export Document Keymaps
vim.keymap.set("n", "<leader>le", ":LspTinymistExportPdf<CR>", { desc = "Typst: Export Pdf" })
vim.keymap.set("n", "<leader>lh", ":LspTinymistExportHtml<CR>", { desc = "Typst: Export Html" })
vim.keymap.set("n", "<leader>lm", ":LspTinymistExportMarkdown<CR>", { desc = "Typst: Export Markdown" })

-- INFO: LSP: Export Image Keymaps
vim.keymap.set("n", "<leader>lj", ":LspTinymistExportPng<CR>", { desc = "Typst: Export Png" })
vim.keymap.set("n", "<leader>ls", ":LspTinymistExportSvg<CR>", { desc = "Typst: Export Svg" })

-- INFO: Typst Preview
vim.keymap.set("n", "<leader>lp", function()
	vim.cmd("TypstPreview")
end, { desc = "Typst: Preview Document" })
vim.keymap.set("n", "<leader>lq", ":TypstPreviewStop<CR>", { desc = "Typst: Stop Preview" })
vim.keymap.set("n", "<leader>lc", ":TypstPreviewSyncCursor<CR>", { desc = "Typst: Sync Cursor" })
