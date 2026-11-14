-- NOTE: Enable LSP Servers
vim.lsp.enable(require("core.config").lsp)

-- NOTE: LSP Attach & Detach
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Jump to the definition of the word under your cursor.
		map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		-- Find references for the word under your cursor.
		map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
		-- Jump to the implementation of the word under your cursor.
		map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
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
local complete_client = function(arg)
	return vim.iter(vim.lsp.get_clients())
		:map(function(client)
			return client.name
		end)
		:filter(function(name)
			return name:sub(1, #arg) == arg
		end)
		:totable()
end

vim.api.nvim_create_user_command("LspInfo", ":checkhealth vim.lsp", { desc = "Alias to `:checkhealth vim.lsp`" })

vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd(string.format("tabnew %s", vim.lsp.log.get_filename()))
end, { desc = "Opens the Nvim LSP Client log" })

vim.api.nvim_create_user_command("LspRestart", function(info)
	local client_names = info.fargs

	-- Default to restarting all active servers
	if #client_names == 0 then
		client_names = vim.iter(vim.lsp.get_clients())
			:map(function(client)
				return client.name
			end)
			:totable()
	end

	for name in vim.iter(client_names) do
		if vim.lsp.config[name] == nil then
			vim.notify(("Invalid server name '%s'"):format(name))
		else
			vim.lsp.enable(name, false)
			if info.bang then
				vim.iter(vim.lsp.get_clients({ name = name })):each(function(client)
					client:stop(true)
				end)
			end
		end
	end

	local timer = assert(vim.uv.new_timer())
	timer:start(500, 0, function()
		for name in vim.iter(client_names) do
			vim.schedule_wrap(vim.lsp.enable)(name)
		end
		timer:close()
	end)
end, {
	desc = "Restart the given LSP client",
	nargs = "?",
	bang = true,
	complete = complete_client,
})
