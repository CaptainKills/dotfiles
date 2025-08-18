-- Vim Local Options:
vim.cmd([[
	setlocal textwidth=100
	setlocal formatoptions+=t
	setlocal linebreak
]])

-- Format Paragraph Keymap
vim.keymap.set("n", "gq", "vipgq", { desc = "Format paragraph according to formatoptions" })

-- LSP: General Keymaps
vim.keymap.set("n", "<leader>li", ":LspTinymistGetServerInfo<CR>", { desc = "Typst: Get LSP Info" })
vim.keymap.set("n", "<leader>ld", ":LspTinymistGetDocumentMetrics<CR>", { desc = "Typst: Get Document Metrics" })
vim.keymap.set("n", "<leader>lw", ":LspTinymistGetWorkspaceLabels<CR>", { desc = "Typst: Get Workspace Labels" })
vim.keymap.set("n", "<leader>lt", ":LspTinymistGetDocumentTrace<CR>", { desc = "Typst: Get Document Trace" })

-- LSP: Export Document Keymaps
vim.keymap.set("n", "<leader>le", ":LspTinymistExportPdf<CR>", { desc = "Typst: Export Pdf" })
vim.keymap.set("n", "<leader>lh", ":LspTinymistExportHtml<CR>", { desc = "Typst: Export Html" })
vim.keymap.set("n", "<leader>lm", ":LspTinymistExportMarkdown<CR>", { desc = "Typst: Export Markdown" })

-- LSP: Export Image Keymaps
vim.keymap.set("n", "<leader>lj", ":LspTinymistExportPng<CR>", { desc = "Typst: Export Png" })
vim.keymap.set("n", "<leader>ls", ":LspTinymistExportSvg<CR>", { desc = "Typst: Export Svg" })

-- Typst Preview
local preview_start = function()
	-- Start Typst Preview
	vim.cmd("TypstPreview")

	-- Pin previewed file as main
	local bufnr = vim.api.nvim_get_current_buf()
	local buffer = vim.api.nvim_buf_get_name(bufnr)
	local clients = vim.iter(vim.lsp.get_clients())

	for lsp in clients do
		if lsp.name == "tinymist" then
			lsp:exec_cmd({
				title = "pin",
				command = "tinymist.pinMain",
				arguments = { buffer },
			}, { bufnr = bufnr })
		end
	end
end

local preview_stop = function()
	-- Stop Typst Preview
	vim.cmd("TypstPreviewStop")

	-- Unpin previewed file as main
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.iter(vim.lsp.get_clients())

	for lsp in clients do
		if lsp.name == "tinymist" then
			lsp:exec_cmd({
				title = "unpin",
				command = "tinymist.pinMain",
				arguments = { vim.v.null },
			}, { bufnr = bufnr })
		end
	end
end

vim.keymap.set("n", "<leader>lp", preview_start, { desc = "Typst: Start Preview Document" })
vim.keymap.set("n", "<leader>lq", preview_stop, { desc = "Typst: Stop Preview Document" })
vim.keymap.set("n", "<leader>lc", ":TypstPreviewSyncCursor<CR>", { desc = "Typst: Sync Cursor with Preview" })
