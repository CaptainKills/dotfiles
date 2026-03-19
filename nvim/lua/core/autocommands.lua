-- Register Autocommand Function
local register_autocmd = function(name, file)
	vim.api.nvim_create_autocmd("VimEnter", {
		group = vim.api.nvim_create_augroup(name, { clear = true }),
		callback = function()
			vim.schedule(function()
				local cwd = vim.fn.getcwd()

				if vim.fn.filereadable(cwd .. "/" .. file) == 1 then
					vim.cmd("edit " .. file)
				end
			end)
		end,
	})
end

-- Open Default Buffers
register_autocmd("Lua", "init.lua")
register_autocmd("C", "src/main.c")
register_autocmd("Golang", "main.go")
register_autocmd("Rust", "src/main.rs")
register_autocmd("Python", "main.py")
register_autocmd("Typst", "main.typ")
