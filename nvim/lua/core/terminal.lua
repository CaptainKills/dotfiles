-- NOTE: Terminal Mode 'Exit' Keymap
vim.keymap.set("t", "<Esc>", "<c-\\><c-n>", { desc = "Exit Terminal Mode" })

vim.api.nvim_create_autocmd("TermOpen", {
	desc = "Overwrite Options In Terminal Window",
	group = vim.api.nvim_create_augroup("Custom-Term-Open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

local state = {
	buf = -1,
	win = -1,
}

-- NOTE: Main 'Toggle Terminal' Function
local create_floating_window = function(opts)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)

	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local buffer = nil
	if vim.api.nvim_buf_is_valid(opts.buffer) then
		buffer = opts.buffer
	else
		buffer = vim.api.nvim_create_buf(false, true)
	end

	local window_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
	}

	local window = vim.api.nvim_open_win(buffer, true, window_config)

	return { buf = buffer, win = window }
end

local toggle_terminal = function()
	local window_valid = vim.api.nvim_win_is_valid(state.win)

	if not window_valid then
		state = create_floating_window({ buffer = state.buf })

		if vim.bo[state.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
		end
	else
		vim.api.nvim_win_hide(state.win)
	end
end

-- NOTE: Terminal Mode 'Enter' Keymap
vim.keymap.set("n", "<leader>tt", toggle_terminal, { desc = "[T]oggle [T]erminal" })
