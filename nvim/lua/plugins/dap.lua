return {
	-- NOTE: Debug Adapter Protocol
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
		},

		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- NOTE: DAP Keymaps
			vim.keymap.set("n", "<F1>", dap.continue, { desc = "DAP: Start Debugger" })
			vim.keymap.set("n", "<F2>", dap.step_into, { desc = "DAP: Step Into" })
			vim.keymap.set("n", "<F3>", dap.step_over, { desc = "DAP: Step Over" })
			vim.keymap.set("n", "<F4>", dap.step_out, { desc = "DAP: Step Out" })
			vim.keymap.set("n", "<F5>", dap.step_back, { desc = "DAP Step Back" })
			vim.keymap.set("n", "<F6>", dap.restart, { desc = "DAP: Restart Debugger" })

			vim.keymap.set("n", "<F12>", function()
				dapui.toggle({ reset = true })
			end, { desc = "DAP: Open/Close UI" })

			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>?", function()
				dapui.eval(nil, { enter = true })
			end, { desc = "DAP: Evaluate Variable" })

			-- NOTE: DAP UI
			dap.listeners.before.attach.dapui_config = function()
				dapui.open({ reset = true })
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open({ reset = true })
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				-- dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				-- dapui.close()
			end
		end,
	},

	-- NOTE: DAP User Interface
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "nvim-neotest/nvim-nio" },

		opts = {
			layouts = {
				{
					elements = {
						{
							id = "breakpoints",
							size = 0.33,
						},
						{
							id = "scopes",
							size = 0.33,
						},
						{
							id = "watches",
							size = 0.33,
						},
					},
					position = "right",
					size = 0.3,
				},
				{
					elements = {
						{
							id = "repl",
							size = 0.5,
						},
						{
							id = "console",
							size = 0.5,
						},
					},
					position = "bottom",
					size = 0.3,
				},
			},
		},
	},

	-- NOTE: DAP Virtual Test
	{
		"theHamsta/nvim-dap-virtual-text",
		opts = {
			virt_text_pos = "eol",
		},
	},

	-- NOTE: C/C++ Debugger
	{
		"julianolf/nvim-dap-lldb",
		ft = { "c", "cpp" },
		opts = {},
	},

	-- NOTE: Go Debugger
	{
		"leoluz/nvim-dap-go",
		ft = { "go" },
		opts = {},
	},
}
