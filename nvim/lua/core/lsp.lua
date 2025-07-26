-- NOTE: Enable LSP Servers
vim.lsp.enable(require("core.config").lsp)

-- NOTE: LSP Attach & Detach
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Jump to the definition of the word under your cursor.
		map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
		-- Find references for the word under your cursor.
		map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
		-- Jump to the implementation of the word under your cursor.
		map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
		-- Jump to the type of the word under your cursor.
		map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
		-- Fuzzy find all the symbols in your current document.
		map("<leader>ds", vim.lsp.buf.document_symbol, "[D]ocument [S]ymbols")
		-- Fuzzy find all the symbols in your current workspace.
		map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		-- Rename the variable under your cursor.
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		-- Execute a code action, usually your cursor needs to be on top of an error
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		-- Opens a popup that displays documentation about the word under your cursor
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		-- This is not Goto Definition, this is Goto Declaration.
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})
		end

		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

vim.api.nvim_create_autocmd("LspDetach", {
	group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			vim.lsp.buf.clear_references()
			vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event.buf })
		end
	end,
})

-- NOTE: LSP User Commands
vim.api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", { desc = "Alias to `:checkhealth vim.lsp`" })

vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd(string.format("tabnew %s", vim.lsp.get_log_path()))
end, { desc = "Opens the Nvim LSP Client log" })

vim.api.nvim_create_user_command("LspRestart", function(info)
	local clients = info.fargs

	-- Default to restarting all active servers
	if #clients == 0 then
		clients = vim.iter(vim.lsp.get_clients())
			:map(function(client)
				return client.name
			end)
			:totable()
	end

	for _, name in ipairs(clients) do
		if vim.lsp.config[name] == nil then
			vim.notify(("Invalid server name '%s'"):format(name))
		else
			vim.lsp.enable(name, false)
		end
	end

	local timer = assert(vim.uv.new_timer())
	timer:start(500, 0, function()
		for _, name in ipairs(clients) do
			vim.schedule_wrap(function(x)
				vim.lsp.enable(x)
			end)(name)
		end
	end)
end, { desc = "Restart the given Nvim LSP Client" })
