vim.opt.commentstring = "% %s"

-- mCRL2 Neovim ftplugin integration
-- Converted from VSCode mCRL2 extension

local bufnr = vim.api.nvim_get_current_buf()

-- Equivalence Types definition
local equivalence_types = {
	["Weak Trace Equivalence"] = "weak-trace",
	["Strong Trace Equivalence"] = "trace",
	["Weak Bisimilarity"] = "weak-bisim",
	["Strong Bisilimarity (O(mlogn))"] = "bisim",
	["Strong Bisilimarity (O(mn))"] = "bisim-gv",
	["Strong Bisilimarity (O(mlogm))"] = "bisim-gjkw",
	["Branching Bisilimarity (O(mlogn))"] = "branching-bisim",
	["Branching Bisilimarity (O(mn))"] = "branching-bisim-gv",
	["Branching Bisilimarity (O(mlogm))"] = "branching-bisim-gjkw",
	["Divergence-preserving Branching Bisilimarity (O(mlogn))"] = "dpbranching-bisim",
	["Divergence-preserving Branching Bisilimarity (O(mn))"] = "dpbranching-bisim-gv",
	["Divergence-preserving Branching Bisilimarity (O(mlogm))"] = "dpbranching-bisim-gjkw",
	["Divergence-preserving Weak Bisimilarity"] = "dpweak-bisim",
	["Strong Simulation Equivalence"] = "sim",
	["Strong Ready Simulation Equivalence"] = "ready-sim",
	["Coupled Simulation Equivalence"] = "coupled-sim",
	["Tau Star Reduction"] = "tau-star",
}

local equivalence_names = {
	"Weak Trace Equivalence",
	"Strong Trace Equivalence",
	"Weak Bisimilarity",
	"Strong Bisilimarity (O(mlogn))",
	"Strong Bisilimarity (O(mn))",
	"Strong Bisilimarity (O(mlogm))",
	"Branching Bisilimarity (O(mlogn))",
	"Branching Bisilimarity (O(mn))",
	"Branching Bisilimarity (O(mlogm))",
	"Divergence-preserving Branching Bisilimarity (O(mlogn))",
	"Divergence-preserving Branching Bisilimarity (O(mn))",
	"Divergence-preserving Branching Bisilimarity (O(mlogm))",
	"Divergence-preserving Weak Bisimilarity",
	"Strong Simulation Equivalence",
	"Strong Ready Simulation Equivalence",
	"Coupled Simulation Equivalence",
	"Tau Star Reduction",
}

local equivalence_blacklist = {
	["tau-star"] = true,
}

local reduction_blacklist = {
	["coupled-sim"] = true,
}

--------------------------------------------------------------------------------
-- Output Channel Management
--------------------------------------------------------------------------------

local function get_output_buf()
	-- 1. Check if a buffer named [mCRL2 Output] already exists
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(b) then
			local name = vim.api.nvim_buf_get_name(b)
			if name:find("%[mCRL2 Output%]$") or vim.fn.bufname(b) == "[mCRL2 Output]" then
				vim.bo[b].buftype = "nofile"
				vim.bo[b].bufhidden = "hide"
				vim.bo[b].swapfile = false
				vim.bo[b].modifiable = true
				return b
			end
		end
	end

	-- 2. Create a new unlisted scratch buffer
	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "hide"
	vim.bo[buf].swapfile = false
	vim.bo[buf].modifiable = true
	pcall(vim.api.nvim_buf_set_name, buf, "[mCRL2 Output]")
	vim.api.nvim_create_autocmd("BufWinEnter", {
		buffer = buf,
		callback = function()
			vim.wo.wrap = true
		end,
	})
	vim.keymap.set(
		"n",
		"q",
		"<cmd>close<CR>",
		{ buffer = buf, silent = true, nowait = true, desc = "Close mCRL2 Output" }
	)
	return buf
end

local function output_show()
	local buf = get_output_buf()
	for _, w in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_is_valid(w) and vim.api.nvim_win_get_buf(w) == buf then
			vim.wo[w].wrap = true
			return w
		end
	end

	local cur_win = vim.api.nvim_get_current_win()
	vim.cmd("botright 12split")
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)
	vim.wo[win].wrap = true
	vim.wo[win].number = false
	vim.wo[win].relativenumber = false
	if vim.api.nvim_win_is_valid(cur_win) then
		vim.api.nvim_set_current_win(cur_win)
	end
	return win
end

local function output_close()
	vim.schedule(function()
		local buf = get_output_buf()
		for _, w in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_is_valid(w) and vim.api.nvim_win_get_buf(w) == buf then
				pcall(vim.api.nvim_win_close, w, true)
			end
		end
	end)
end

local function output_clear()
	local buf = get_output_buf()
	if vim.api.nvim_buf_is_valid(buf) then
		vim.bo[buf].modifiable = true
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
	end
end

local function output_append(text)
	text = text:gsub("\r\n", "\n"):gsub("\r", "\n")
	vim.schedule(function()
		local buf = get_output_buf()
		if not vim.api.nvim_buf_is_valid(buf) then
			return
		end

		local lines = vim.split(text, "\n", { plain = true })
		local count = vim.api.nvim_buf_line_count(buf)
		local last_line = (count > 0) and vim.api.nvim_buf_get_lines(buf, count - 1, count, false)[1] or ""

		lines[1] = last_line .. lines[1]

		vim.bo[buf].modifiable = true
		if count == 0 or (count == 1 and last_line == "") then
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		else
			vim.api.nvim_buf_set_lines(buf, count - 1, count, false, lines)
		end

		for _, w in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_is_valid(w) and vim.api.nvim_win_get_buf(w) == buf then
				local new_count = vim.api.nvim_buf_line_count(buf)
				pcall(vim.api.nvim_win_set_cursor, w, { new_count, 0 })
			end
		end

		pcall(vim.cmd, "redraw")
	end)
end

local function output_append_line(text)
	output_append((text or "") .. "\n")
end

--------------------------------------------------------------------------------
-- Path & Filesystem Helpers
--------------------------------------------------------------------------------

local function get_project_dir()
	local active_file = vim.api.nvim_buf_get_name(bufnr)
	local file_dir = (active_file ~= "") and vim.fs.dirname(active_file) or vim.fn.getcwd()

	if active_file ~= "" then
		local root_markers = { ".mcrl2proj", ".git", ".gitignore" }
		if vim.fs.root then
			local root = vim.fs.root(active_file, root_markers)
			if root then
				return root
			end
		elseif vim.fs.find then
			local found = vim.fs.find(root_markers, { upward = true, path = file_dir })[1]
			if found then
				return vim.fs.dirname(found)
			end
		end

		local cwd = vim.fs.normalize(vim.fn.getcwd())
		local norm_file = vim.fs.normalize(active_file)
		if norm_file:sub(1, #cwd) == cwd then
			return cwd
		end

		return file_dir
	end

	return vim.fn.getcwd()
end

local function to_project_path(path_name)
	local dir = get_project_dir()
	if not path_name or path_name:match("^%s*$") then
		return vim.fs.normalize(dir)
	end
	local trimmed = path_name:gsub("^%s*(.-)%s*$", "%1")
	if trimmed:sub(1, 2) == "./" then
		trimmed = trimmed:sub(3)
	end
	return vim.fs.normalize(dir .. "/" .. trimmed)
end

local function ensure_directory(dir)
	if vim.fn.isdirectory(dir) == 0 then
		vim.fn.mkdir(dir, "p")
	end
end

local function get_files(dir, with_extension)
	local uv = vim.uv or vim.loop
	local results = {}
	local function scan(current_dir)
		local handle = uv.fs_scandir(current_dir)
		if not handle then
			return
		end
		while true do
			local name, type = uv.fs_scandir_next(handle)
			if not name then
				break
			end
			if name ~= "." and name ~= ".." and name ~= ".git" and name ~= "out" and name ~= "node_modules" then
				local full_path = current_dir .. "/" .. name
				if not type then
					local stat = uv.fs_stat(full_path)
					type = stat and stat.type
				end
				if type == "directory" then
					scan(full_path)
				elseif type == "file" then
					if not with_extension or with_extension == "" or name:sub(-#with_extension) == with_extension then
						table.insert(results, vim.fs.normalize(full_path))
					end
				end
			end
		end
	end
	scan(dir)
	return results
end

local function get_relative_path(base, path)
	base = vim.fs.normalize(base)
	path = vim.fs.normalize(path)
	if path:sub(1, #base) == base then
		local rel = path:sub(#base + 1)
		if rel:sub(1, 1) == "/" then
			rel = rel:sub(2)
		end
		return rel
	end
	return path
end

local function transform_file_name(file_name)
	local project_dir = to_project_path()
	local rel = get_relative_path(project_dir, file_name)
	rel = rel:gsub("^[/\\]+", "")
	local replaced = rel:gsub("[/\\]", ".")
	local parts = vim.split(replaced, ".", { plain = true })
	if #parts > 1 then
		table.remove(parts, #parts)
	end
	local result = table.concat(parts, ".")
	return result:gsub("^%.+", "")
end

local function to_output_file_name(file_name, extension)
	local base_name = transform_file_name(file_name)
	return to_project_path("./out/" .. base_name .. extension)
end

--------------------------------------------------------------------------------
-- Process Execution
--------------------------------------------------------------------------------

local function create_command(cmd)
	local bin_path = vim.b[bufnr].mcrl2_bin_path or vim.g.mcrl2_bin_path or ""
	bin_path = bin_path:gsub("^%s*(.-)%s*$", "%1")
	cmd = cmd:gsub("^%s*(.-)%s*$", "%1")

	if #bin_path == 0 then
		return cmd
	end

	local full = vim.fs.normalize(bin_path .. "/" .. cmd)
	return vim.fn.shellescape(full)
end

local function run(cmd, callback, suppressed, error_callback)
	callback = callback or function() end
	error_callback = error_callback or function() end
	suppressed = suppressed or false

	local out_dir = to_project_path("./out")
	ensure_directory(out_dir)

	if not suppressed then
		output_append_line("> " .. cmd)
	end

	local result = ""

	local function handle_output(data)
		if not data then
			return
		end
		local text = table.concat(data, "\n")
		if text ~= "" then
			if not suppressed then
				output_append(text)
			end
			result = result .. text:gsub("\r\n", "\n"):gsub("\r", "\n")
		end
	end

	local job_id = vim.fn.jobstart({ "sh", "-c", cmd }, {
		cwd = out_dir,
		on_stdout = function(_, data)
			handle_output(data)
		end,
		on_stderr = function(_, data)
			handle_output(data)
		end,
		on_exit = function(_, code)
			local trimmed = result:gsub("^%s*(.-)%s*$", "%1")
			if code == 0 then
				callback(trimmed)
			else
				if not suppressed then
					output_show()
				end
				error_callback(trimmed)
			end
		end,
	})

	if job_id <= 0 then
		output_append_line("[mCRL2 Error] Failed to start process: " .. cmd)
		output_show()
		error_callback("Failed to start process")
	end
end

local function run_mcrl2(cmd, args, callback, suppressed, error_callback)
	if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].modified then
		vim.api.nvim_buf_call(bufnr, function()
			vim.cmd("silent write")
		end)
	end

	local verbose = vim.b[bufnr].mcrl2_verbose or vim.g.mcrl2_verbose or false
	local arg_parts = {}
	for _, arg in ipairs(args) do
		local trimmed = arg:gsub("^%s*(.-)%s*$", "%1")
		if trimmed == "|" then
			table.insert(arg_parts, "|")
		elseif trimmed:find("^%-") then
			table.insert(arg_parts, trimmed)
		else
			table.insert(arg_parts, vim.fn.shellescape(trimmed))
		end
	end
	local arg_string = table.concat(arg_parts, " ")
	local verbose_flag = verbose and " -v " or " "
	local full_cmd = create_command(cmd) .. verbose_flag .. arg_string

	run(full_cmd, callback, suppressed, error_callback)
end

--------------------------------------------------------------------------------
-- mCRL2 Pipeline Utilities
--------------------------------------------------------------------------------

local function mcrl22lps(file_name, callback, error_callback)
	callback = callback or function() end
	error_callback = error_callback or function() end
	local alg = vim.b[bufnr].mcrl2_linearization_algorithm or vim.g.mcrl2_linearization_algorithm or "regular"
	alg = alg:gsub("^%s*(.-)%s*$", "%1")
	local flag = (alg ~= "") and ("-l" .. alg) or "-lregular"
	run_mcrl2("mcrl22lps", { flag, file_name, to_output_file_name(file_name, ".lps") }, callback, false, error_callback)
end

local function lps2lts(file_name, callback, error_callback)
	callback = callback or function() end
	error_callback = error_callback or function() end
	run_mcrl2(
		"lps2lts",
		{ "-v", to_output_file_name(file_name, ".lps"), to_output_file_name(file_name, ".lts") },
		callback,
		false,
		error_callback
	)
end

local function mcrl22lts(file_name, callback, error_callback)
	callback = callback or function() end
	error_callback = error_callback or function() end
	mcrl22lps(file_name, function()
		lps2lts(file_name, callback, error_callback)
	end, error_callback)
end

--------------------------------------------------------------------------------
-- Operations
--------------------------------------------------------------------------------

local function clean()
	local out_dir = to_project_path("./out")
	if vim.fn.isdirectory(out_dir) == 1 then
		vim.fn.delete(out_dir, "rf")
	end
	ensure_directory(out_dir)
	output_append_line("Cleaned output directory: " .. out_dir)
	output_close()
	vim.notify("[mCRL2] Cleaned output directory: " .. out_dir, vim.log.levels.INFO)
end

local function parse()
	local active_file = vim.api.nvim_buf_get_name(bufnr)
	if active_file == "" then
		output_append_line("[mCRL2 Error] No active file name for this buffer.")
		return
	end
	run_mcrl2("mcrl22lps", { "-e", active_file }, function(result)
		if result == "" then
			output_append_line("[mCRL2] Specification parsed successfully. No errors found.")
		end
		output_close()
		vim.notify("[mCRL2] Specification parsed successfully. No errors found.", vim.log.levels.INFO)
	end)
end

local function show_graph()
	local active_file = vim.api.nvim_buf_get_name(bufnr)
	if active_file == "" then
		output_append_line("[mCRL2 Error] No active file name for this buffer.")
		return
	end
	mcrl22lts(active_file, function()
		output_append_line("[mCRL2] Launching ltsgraph...")
		output_close()
		vim.notify("[mCRL2] Launching ltsgraph...", vim.log.levels.INFO)
		run_mcrl2(
			"ltsgraph",
			{ to_output_file_name(active_file, ".lts") },
			function()
				output_close()
			end,
			false,
			function()
				output_show()
				output_append_line("[mCRL2 Error] Failed to run ltsgraph.")
			end
		)
	end)
end

local function simulate()
	local active_file = vim.api.nvim_buf_get_name(bufnr)
	if active_file == "" then
		output_append_line("[mCRL2 Error] No active file name for this buffer.")
		return
	end
	mcrl22lps(active_file, function()
		output_append_line("[mCRL2] Launching lpsxsim...")
		output_close()
		vim.notify("[mCRL2] Launching lpsxsim...", vim.log.levels.INFO)
		run_mcrl2(
			"lpsxsim",
			{ to_output_file_name(active_file, ".lps") },
			function()
				output_close()
			end,
			false,
			function()
				output_show()
				output_append_line("[mCRL2 Error] Failed to run lpsxsim.")
			end
		)
	end)
end

local function verify_next_property(files, success, total, lps_file)
	if #files == 0 then
		output_append_line("Finished verifying properties.")
		output_append_line("Successfully verified: " .. success .. "/" .. total)
		if success == total and total > 0 then
			output_close()
			vim.notify(
				string.format("[mCRL2] Successfully verified all properties (%d/%d).", success, total),
				vim.log.levels.INFO
			)
		else
			output_show()
			vim.notify(
				string.format("[mCRL2] Property verification: %d/%d passed. Check output.", success, total),
				vim.log.levels.WARN
			)
		end
		return
	end

	local head = files[1]
	local tail = {}
	for i = 2, #files do
		table.insert(tail, files[i])
	end

	local on_result = function(result)
		local name = get_relative_path(to_project_path(), head)
		if result == "true" then
			output_append_line("[SUCCEEDED] " .. name)
			success = success + 1
		else
			output_append_line("[FAILED] " .. name)
			if result ~= "false" and result ~= "" then
				output_append_line(result)
			end
		end
		verify_next_property(tail, success, total + 1, lps_file)
	end

	run_mcrl2("lps2pbes", { lps_file, "-f", head, "|", create_command("pbes2bool") }, on_result, true, on_result)
end

local function verify_properties()
	local dir = to_project_path()
	local files = get_files(dir, ".mcf")
	local active_file = vim.api.nvim_buf_get_name(bufnr)
	if active_file == "" then
		output_append_line("[mCRL2 Error] No active file name for this buffer.")
		return
	end

	output_append_line("Starting property verification for " .. #files .. " properties:")
	if #files == 0 then
		output_append_line("No .mcf property files found in " .. dir)
		return
	end

	mcrl22lps(active_file, function()
		verify_next_property(files, 0, 0, to_output_file_name(active_file, ".lps"))
	end)
end

local function equivalence()
	local dir = to_project_path()
	local files = get_files(dir, ".mcrl2")
	local names = {}
	local map = {}

	for _, file in ipairs(files) do
		local name = get_relative_path(dir, file)
		table.insert(names, name)
		map[name] = file
	end

	if #names == 0 then
		output_append_line("No .mcrl2 files found in project directory: " .. dir)
		return
	end

	local active_file = vim.api.nvim_buf_get_name(bufnr)
	if active_file == "" then
		output_append_line("[mCRL2 Error] No active file name for this buffer.")
		return
	end

	vim.ui.select(names, { prompt = "Select mCRL2 file to compare with:" }, function(chosen_file_name)
		if not chosen_file_name then
			output_append_line("[mCRL2] Equivalence check cancelled.")
			output_close()
			return
		end

		local file = map[chosen_file_name]

		local available_equivalences = {}
		for _, name in ipairs(equivalence_names) do
			local eq_type = equivalence_types[name]
			if not equivalence_blacklist[eq_type] then
				table.insert(available_equivalences, name)
			end
		end

		vim.ui.select(available_equivalences, { prompt = "Select equivalence type:" }, function(chosen_eq_name)
			if not chosen_eq_name then
				output_append_line("[mCRL2] Equivalence check cancelled.")
				output_close()
				return
			end

			local eq = equivalence_types[chosen_eq_name]
			output_append_line("[mCRL2] Comparing with " .. chosen_file_name .. " (" .. eq .. ")...")
			mcrl22lts(active_file, function()
				mcrl22lts(file, function()
					run_mcrl2("ltscompare", {
						"-c",
						"--equivalence=" .. eq,
						to_output_file_name(active_file, ".lts"),
						to_output_file_name(file, ".lts"),
					}, function(result)
						local lines = vim.split(result, "\n", { plain = true })
						local last_line = lines[#lines]
						if last_line == "false" then
							output_append_line("\nCounter Example Trace:")
							run_mcrl2("tracepp", { to_project_path("./out/Counterexample0.trc") })
						else
							output_append_line("\n[mCRL2] Specifications are equivalent (" .. eq .. ").")
							output_close()
							vim.notify("[mCRL2] Specifications are equivalent (" .. eq .. ").", vim.log.levels.INFO)
						end
					end)
				end)
			end)
		end)
	end)
end

local function reduced()
	local active_file = vim.api.nvim_buf_get_name(bufnr)
	if active_file == "" then
		output_append_line("[mCRL2 Error] No active file name for this buffer.")
		return
	end

	local available_reductions = {}
	for _, name in ipairs(equivalence_names) do
		local eq_type = equivalence_types[name]
		if not reduction_blacklist[eq_type] then
			table.insert(available_reductions, name)
		end
	end

	vim.ui.select(available_reductions, { prompt = "Select reduction equivalence:" }, function(chosen_eq_name)
		if not chosen_eq_name then
			output_append_line("[mCRL2] Reduction cancelled.")
			output_close()
			return
		end

		local eq = equivalence_types[chosen_eq_name]
		local out_extension = "." .. eq .. ".lts"
		output_append_line("[mCRL2] Reducing LTS (" .. eq .. ")...")

		mcrl22lts(active_file, function()
			run_mcrl2("ltsconvert", {
				"--equivalence=" .. eq,
				to_output_file_name(active_file, ".lts"),
				to_output_file_name(active_file, out_extension),
			}, function()
				output_append_line("[mCRL2] Launching ltsgraph for reduced LTS...")
				output_close()
				vim.notify("[mCRL2] Launching ltsgraph for reduced LTS...", vim.log.levels.INFO)
				run_mcrl2(
					"ltsgraph",
					{ to_output_file_name(active_file, out_extension) },
					function()
						output_close()
					end,
					false,
					function()
						output_show()
						output_append_line("[mCRL2 Error] Failed to run ltsgraph.")
					end
				)
			end)
		end)
	end)
end

--------------------------------------------------------------------------------
-- Command Wrapper & Registration
--------------------------------------------------------------------------------

local function wrap_command(func)
	return function()
		output_clear()
		output_show()
		ensure_directory(to_project_path("./out"))
		func()
	end
end

-- Buffer-local User Commands
vim.api.nvim_buf_create_user_command(bufnr, "MCRL2Parse", wrap_command(parse), { desc = "Parse mCRL2 specification" })
vim.api.nvim_buf_create_user_command(
	bufnr,
	"MCRL2ShowGraph",
	wrap_command(show_graph),
	{ desc = "Generate and show LTS graph" }
)
vim.api.nvim_buf_create_user_command(
	bufnr,
	"MCRL2Simulate",
	wrap_command(simulate),
	{ desc = "Simulate mCRL2 specification" }
)
vim.api.nvim_buf_create_user_command(
	bufnr,
	"MCRL2VerifyProperties",
	wrap_command(verify_properties),
	{ desc = "Verify MCF properties" }
)
vim.api.nvim_buf_create_user_command(
	bufnr,
	"MCRL2Equivalence",
	wrap_command(equivalence),
	{ desc = "Check equivalence with another specification" }
)
vim.api.nvim_buf_create_user_command(
	bufnr,
	"MCRL2Reduced",
	wrap_command(reduced),
	{ desc = "Generate and show reduced LTS" }
)
vim.api.nvim_buf_create_user_command(
	bufnr,
	"MCRL2Clean",
	wrap_command(clean),
	{ desc = "Clean mCRL2 output directory" }
)

-- Buffer-local Keymaps Helper
local map = function(keys, func, desc)
	vim.keymap.set("n", keys, wrap_command(func), { buffer = bufnr, silent = true, desc = "mCRL2: " .. desc })
end

-- Keymaps with <leader>m
map("<leader>mp", parse, "Parse specification")
map("<leader>mg", show_graph, "Show LTS graph")
map("<leader>ms", simulate, "Simulate specification")
map("<leader>mv", verify_properties, "Verify properties (.mcf)")
map("<leader>me", equivalence, "Equivalence check")
map("<leader>mr", reduced, "Show reduced LTS")
map("<leader>mc", clean, "Clean output directory")

-- Undo ftplugin support
vim.b[bufnr].undo_ftplugin = (vim.b[bufnr].undo_ftplugin and (vim.b[bufnr].undo_ftplugin .. " | ") or "")
	.. "silent! execute 'nunmap <buffer> <leader>mp' | "
	.. "silent! execute 'nunmap <buffer> <leader>mg' | "
	.. "silent! execute 'nunmap <buffer> <leader>ms' | "
	.. "silent! execute 'nunmap <buffer> <leader>mv' | "
	.. "silent! execute 'nunmap <buffer> <leader>me' | "
	.. "silent! execute 'nunmap <buffer> <leader>mr' | "
	.. "silent! execute 'nunmap <buffer> <leader>mc' | "
	.. "silent! delcommand MCRL2Parse | "
	.. "silent! delcommand MCRL2ShowGraph | "
	.. "silent! delcommand MCRL2Simulate | "
	.. "silent! delcommand MCRL2VerifyProperties | "
	.. "silent! delcommand MCRL2Equivalence | "
	.. "silent! delcommand MCRL2Reduced | "
	.. "silent! delcommand MCRL2Clean"
