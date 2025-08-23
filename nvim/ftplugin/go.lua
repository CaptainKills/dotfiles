-- Debug Adapter
local dap = require("dap-go")

-- Vim Keymaps: Go
vim.keymap.set("n", "<leader>gdt", function()
	if vim.bo.filetype == "go" then
		dap.debug_test()
	end
end, { desc = "Go: Debug Test" })

vim.keymap.set("n", "<leader>gdlt", function()
	if vim.bo.filetype == "go" then
		dap.debug_last_test()
	end
end, { desc = "Go: Debug Last Test" })
