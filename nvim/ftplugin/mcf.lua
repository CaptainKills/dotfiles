vim.opt_local.commentstring = "% %s"

-- MCF Neovim ftplugin integration
-- Helper commands for modal mu-calculus formula (.mcf) verification using the mCRL2 toolset

local bufnr = vim.api.nvim_get_current_buf()

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

local function get_mcrl2_file(callback)
	local dir = to_project_path()
	local files = get_files(dir, ".mcrl2")

	if #files == 0 then
		local active_file = vim.api.nvim_buf_get_name(bufnr)
		local file_dir = (active_file ~= "") and vim.fs.dirname(active_file) or dir
		if vim.fs.find then
			local upward_files = vim.fs.find(function(name)
				return name:match("%.mcrl2$") ~= nil
			end, { upward = true, path = file_dir, type = "file" })
			if #upward_files > 0 then
				files = upward_files
			end
		end
	end

	if #files == 0 then
		output_append_line("[mCRL2 Error] No .mcrl2 files found in project directory: " .. dir)
		output_show()
		vim.notify("[mCRL2] No .mcrl2 files found in project directory.", vim.log.levels.ERROR)
		return
	end

	local override = vim.b[bufnr].mcrl2_spec or vim.g.mcrl2_spec
	if override and override ~= "" then
		local override_path = to_project_path(override)
		if vim.fn.filereadable(override_path) == 1 then
			callback(override_path)
			return
		end
	end

	if #files == 1 then
		callback(files[1])
		return
	end

	local names = {}
	local map = {}
	for _, file in ipairs(files) do
		local name = get_relative_path(dir, file)
		table.insert(names, name)
		map[name] = file
	end

	vim.ui.select(names, { prompt = "Select mCRL2 specification to verify against:" }, function(chosen_file_name)
		if not chosen_file_name then
			output_append_line("[mCRL2] Operation cancelled.")
			output_close()
			return
		end
		callback(map[chosen_file_name])
	end)
end

local function mcrl22lps(file_name, callback, error_callback)
	callback = callback or function() end
	error_callback = error_callback or function() end
	local alg = vim.b[bufnr].mcrl2_linearization_algorithm or vim.g.mcrl2_linearization_algorithm or "regular"
	alg = alg:gsub("^%s*(.-)%s*$", "%1")
	local flag = (alg ~= "") and ("-l" .. alg) or "-lregular"
	run_mcrl2("mcrl22lps", { flag, file_name, to_output_file_name(file_name, ".lps") }, callback, false, error_callback)
end

local function lps2lts(in_file, out_file, callback, error_callback)
	if type(out_file) == "function" then
		error_callback = callback
		callback = out_file
		out_file = to_output_file_name(in_file, ".lts")
		in_file = to_output_file_name(in_file, ".lps")
	end
	callback = callback or function() end
	error_callback = error_callback or function() end
	run_mcrl2("lps2lts", { "-v", in_file, out_file }, callback, false, error_callback)
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

	get_mcrl2_file(function(spec_file)
		mcrl22lps(spec_file, function()
			local lps_file = to_output_file_name(spec_file, ".lps")
			local prop_name = get_relative_path(to_project_path(), active_file)
			run_mcrl2("lps2pbes", { "-e", "-f", active_file, lps_file }, function(result)
				if result:find("well%-formed") or result == "" then
					output_append_line("[mCRL2] Property " .. prop_name .. " is well-formed. No errors found.")
				else
					output_append_line(result)
				end
				output_close()
				vim.notify(
					string.format("[mCRL2] Property '%s' parsed successfully. No errors found.", prop_name),
					vim.log.levels.INFO
				)
			end)
		end)
	end)
end

local function verify_property()
	local active_file = vim.api.nvim_buf_get_name(bufnr)
	if active_file == "" then
		output_append_line("[mCRL2 Error] No active file name for this buffer.")
		return
	end

	get_mcrl2_file(function(spec_file)
		local prop_name = get_relative_path(to_project_path(), active_file)
		local spec_name = get_relative_path(to_project_path(), spec_file)
		output_append_line("[mCRL2] Verifying " .. prop_name .. " against " .. spec_name .. "...")

		mcrl22lps(spec_file, function()
			local lps_file = to_output_file_name(spec_file, ".lps")
			local on_result = function(result)
				local lines = vim.split(result:gsub("%s+$", ""), "\n", { plain = true })
				local last_line = lines[#lines]
				if last_line == "true" then
					output_append_line("[SUCCEEDED] " .. prop_name .. " holds.")
					output_close()
					vim.notify(string.format("[mCRL2] Property '%s' holds (true).", prop_name), vim.log.levels.INFO)
				elseif last_line == "false" then
					output_append_line("[FAILED] " .. prop_name .. " does not hold.")
					output_append_line("Run MCRL2ShowTrace (<leader>mt) to view the counterexample trace.")
					output_show()
					vim.notify(
						string.format("[mCRL2] Property '%s' does not hold (false). Check output.", prop_name),
						vim.log.levels.WARN
					)
				else
					output_append_line("[FAILED] " .. prop_name)
					if result ~= "" then
						output_append_line(result)
					end
					output_show()
					vim.notify(
						string.format("[mCRL2] Verification failed for '%s'. Check output.", prop_name),
						vim.log.levels.ERROR
					)
				end
			end

			run_mcrl2(
				"lps2pbes",
				{ lps_file, "-f", active_file, "|", create_command("pbes2bool") },
				on_result,
				false,
				on_result
			)
		end)
	end)
end

local function show_trace()
	local active_file = vim.api.nvim_buf_get_name(bufnr)
	if active_file == "" then
		output_append_line("[mCRL2 Error] No active file name for this buffer.")
		return
	end

	get_mcrl2_file(function(spec_file)
		local prop_name = get_relative_path(to_project_path(), active_file)
		local spec_name = get_relative_path(to_project_path(), spec_file)
		output_append_line(
			"[mCRL2] Checking property and extracting counterexample for "
				.. prop_name
				.. " against "
				.. spec_name
				.. "..."
		)

		mcrl22lps(spec_file, function()
			local lps_file = to_output_file_name(spec_file, ".lps")
			local evidence_lps = to_output_file_name(active_file, ".evidence.lps")
			local evidence_lts = to_output_file_name(active_file, ".evidence.lts")

			-- Clean any prior evidence or trace files for this property
			local dlk_trc = evidence_lps .. "_dlk_0.trc"
			if vim.fn.filereadable(dlk_trc) == 1 then
				vim.fn.delete(dlk_trc)
			end
			if vim.fn.filereadable(evidence_lps) == 1 then
				vim.fn.delete(evidence_lps)
			end
			if vim.fn.filereadable(evidence_lts) == 1 then
				vim.fn.delete(evidence_lts)
			end

			run_mcrl2(
				"lps2pbes",
				{
					"-c",
					"-f",
					active_file,
					lps_file,
					"|",
					create_command("pbes2bool"),
					"-f",
					lps_file,
					"--evidence-file=" .. vim.fn.shellescape(evidence_lps),
				},
				function(result)
					local lines = vim.split(result:gsub("%s+$", ""), "\n", { plain = true })
					local last_line = lines[#lines]

					if last_line == "true" then
						output_append_line("\n[mCRL2] Property " .. prop_name .. " holds (true).")
						output_append_line("No counterexample trace exists.")
						output_close()
						vim.notify(
							string.format("[mCRL2] Property '%s' holds (true). No counterexample trace.", prop_name),
							vim.log.levels.INFO
						)
						return
					end

					if last_line ~= "false" then
						output_append_line("\n[mCRL2 Error] Verification did not return true/false:")
						output_append_line(result)
						output_show()
						vim.notify(
							string.format("[mCRL2] Verification failed for '%s'. Check output.", prop_name),
							vim.log.levels.ERROR
						)
						return
					end

					output_append_line("\n[FAILED] " .. prop_name .. " does not hold.")
					output_append_line("Generating counterexample trace from evidence...")

					run_mcrl2(
						"lps2lts",
						{ "-v", "-D", "-t1", evidence_lps, evidence_lts },
						function()
							local trc_file = nil
							if vim.fn.filereadable(dlk_trc) == 1 then
								trc_file = dlk_trc
							else
								local base = transform_file_name(active_file)
								local out_dir = to_project_path("./out")
								for _, f in ipairs(get_files(out_dir, ".trc")) do
									if f:find(base, 1, true) then
										trc_file = f
										break
									end
								end
							end

							if trc_file and vim.fn.filereadable(trc_file) == 1 then
								output_append_line("\nCounter Example Trace:")
								local trace_format = vim.b[bufnr].mcrl2_trace_format
									or vim.g.mcrl2_trace_format
									or "plain"
								local trace_args = (trace_format ~= "plain") and { "-f", trace_format, trc_file }
									or { trc_file }
								run_mcrl2("tracepp", trace_args, function()
									output_show()
									vim.notify(
										string.format("[mCRL2] Counterexample trace generated for '%s'.", prop_name),
										vim.log.levels.WARN
									)
								end)
							else
								if vim.fn.filereadable(evidence_lts) == 1 then
									output_append_line(
										"\nNo linear deadlock trace found. Counterexample transitions (Aldebaran format):"
									)
									run_mcrl2("ltsconvert", { "-o", "aut", evidence_lts }, function()
										output_append_line(
											"\nYou can inspect the counterexample LTS using MCRL2ShowGraph (<leader>mg)."
										)
										output_show()
										vim.notify(
											string.format(
												"[mCRL2] Counterexample transitions displayed for '%s'.",
												prop_name
											),
											vim.log.levels.WARN
										)
									end)
								else
									output_append_line("\n[mCRL2 Warning] Could not extract trace from evidence LPS.")
									output_show()
								end
							end
						end,
						false,
						function(err)
							output_append_line(
								"[mCRL2 Error] Failed to generate LTS from evidence LPS: " .. tostring(err)
							)
							output_show()
						end
					)
				end,
				false,
				function(err)
					output_append_line("[mCRL2 Error] Failed to solve PBES for counterexample: " .. tostring(err))
					output_show()
				end
			)
		end)
	end)
end

local function show_graph()
	local active_file = vim.api.nvim_buf_get_name(bufnr)
	if active_file == "" then
		output_append_line("[mCRL2 Error] No active file name for this buffer.")
		return
	end

	local evidence_lts = to_output_file_name(active_file, ".evidence.lts")
	if vim.fn.filereadable(evidence_lts) == 1 then
		output_append_line("[mCRL2] Launching ltsgraph for counterexample...")
		output_close()
		vim.notify("[mCRL2] Launching ltsgraph for counterexample...", vim.log.levels.INFO)
		run_mcrl2(
			"ltsgraph",
			{ evidence_lts },
			function()
				output_close()
			end,
			false,
			function()
				output_show()
				output_append_line("[mCRL2 Error] Failed to run ltsgraph.")
			end
		)
		return
	end

	get_mcrl2_file(function(spec_file)
		mcrl22lps(spec_file, function()
			local lps_file = to_output_file_name(spec_file, ".lps")
			local evidence_lps = to_output_file_name(active_file, ".evidence.lps")

			run_mcrl2("lps2pbes", {
				"-c",
				"-f",
				active_file,
				lps_file,
				"|",
				create_command("pbes2bool"),
				"-f",
				lps_file,
				"--evidence-file=" .. vim.fn.shellescape(evidence_lps),
			}, function()
				lps2lts(evidence_lps, evidence_lts, function()
					output_append_line("[mCRL2] Launching ltsgraph for counterexample/evidence...")
					output_close()
					vim.notify("[mCRL2] Launching ltsgraph for counterexample/evidence...", vim.log.levels.INFO)
					run_mcrl2(
						"ltsgraph",
						{ evidence_lts },
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
	end)
end

local function simulate()
	local active_file = vim.api.nvim_buf_get_name(bufnr)
	if active_file == "" then
		output_append_line("[mCRL2 Error] No active file name for this buffer.")
		return
	end

	local evidence_lps = to_output_file_name(active_file, ".evidence.lps")
	if vim.fn.filereadable(evidence_lps) == 1 then
		output_append_line("[mCRL2] Launching lpsxsim for counterexample...")
		output_close()
		vim.notify("[mCRL2] Launching lpsxsim for counterexample...", vim.log.levels.INFO)
		run_mcrl2(
			"lpsxsim",
			{ evidence_lps },
			function()
				output_close()
			end,
			false,
			function()
				output_show()
				output_append_line("[mCRL2 Error] Failed to run lpsxsim.")
			end
		)
		return
	end

	get_mcrl2_file(function(spec_file)
		mcrl22lps(spec_file, function()
			local lps_file = to_output_file_name(spec_file, ".lps")

			run_mcrl2("lps2pbes", {
				"-c",
				"-f",
				active_file,
				lps_file,
				"|",
				create_command("pbes2bool"),
				"-f",
				lps_file,
				"--evidence-file=" .. vim.fn.shellescape(evidence_lps),
			}, function()
				output_append_line("[mCRL2] Launching lpsxsim for counterexample/evidence...")
				output_close()
				vim.notify("[mCRL2] Launching lpsxsim for counterexample/evidence...", vim.log.levels.INFO)
				run_mcrl2(
					"lpsxsim",
					{ evidence_lps },
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
vim.api.nvim_buf_create_user_command(
	bufnr,
	"MCRL2VerifyProperty",
	wrap_command(verify_property),
	{ desc = "Verify current MCF property" }
)
vim.api.nvim_buf_create_user_command(
	bufnr,
	"MCRL2Verify",
	wrap_command(verify_property),
	{ desc = "Verify current MCF property" }
)
vim.api.nvim_buf_create_user_command(
	bufnr,
	"MCRL2ShowTrace",
	wrap_command(show_trace),
	{ desc = "Show counterexample trace for current property" }
)
vim.api.nvim_buf_create_user_command(
	bufnr,
	"MCRL2CounterExample",
	wrap_command(show_trace),
	{ desc = "Show counterexample trace for current property" }
)
vim.api.nvim_buf_create_user_command(
	bufnr,
	"MCRL2ShowGraph",
	wrap_command(show_graph),
	{ desc = "Generate and show counterexample/evidence graph" }
)
vim.api.nvim_buf_create_user_command(
	bufnr,
	"MCRL2Simulate",
	wrap_command(simulate),
	{ desc = "Simulate counterexample/evidence" }
)
vim.api.nvim_buf_create_user_command(bufnr, "MCRL2Parse", wrap_command(parse), { desc = "Parse MCF state formula" })
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
map("<leader>mv", verify_property, "Verify property")
map("<leader>mt", show_trace, "Show counterexample trace")
map("<leader>mg", show_graph, "Show counterexample graph")
map("<leader>ms", simulate, "Simulate counterexample")
map("<leader>mp", parse, "Parse state formula")
map("<leader>mc", clean, "Clean output directory")

-- Undo ftplugin support
vim.b[bufnr].undo_ftplugin = (vim.b[bufnr].undo_ftplugin and (vim.b[bufnr].undo_ftplugin .. " | ") or "")
	.. "silent! execute 'nunmap <buffer> <leader>mv' | "
	.. "silent! execute 'nunmap <buffer> <leader>mt' | "
	.. "silent! execute 'nunmap <buffer> <leader>mg' | "
	.. "silent! execute 'nunmap <buffer> <leader>ms' | "
	.. "silent! execute 'nunmap <buffer> <leader>mp' | "
	.. "silent! execute 'nunmap <buffer> <leader>mc' | "
	.. "silent! delcommand MCRL2VerifyProperty | "
	.. "silent! delcommand MCRL2Verify | "
	.. "silent! delcommand MCRL2ShowTrace | "
	.. "silent! delcommand MCRL2CounterExample | "
	.. "silent! delcommand MCRL2ShowGraph | "
	.. "silent! delcommand MCRL2Simulate | "
	.. "silent! delcommand MCRL2Parse | "
	.. "silent! delcommand MCRL2Clean"
