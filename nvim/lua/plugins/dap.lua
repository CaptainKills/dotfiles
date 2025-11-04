return {
	-- NOTE: Debug Adapter Protocol
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		dependencies = { "rcarriga/nvim-dap-ui", "theHamsta/nvim-dap-virtual-text" },

		config = function()
			local dap = require("dap")

			-- NOTE: DAP Keymaps
			vim.keymap.set("n", "<F1>", dap.continue, { desc = "DAP: Start Debugger" })
			vim.keymap.set("n", "<F2>", dap.step_into, { desc = "DAP: Step Into" })
			vim.keymap.set("n", "<F3>", dap.step_over, { desc = "DAP: Step Over" })
			vim.keymap.set("n", "<F4>", dap.step_out, { desc = "DAP: Step Out" })
			vim.keymap.set("n", "<F5>", dap.step_back, { desc = "DAP Step Back" })
			vim.keymap.set("n", "<F6>", dap.restart, { desc = "DAP: Restart Debugger" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
		end,
	},

	-- NOTE: DAP User Interface
	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		dependencies = { "nvim-neotest/nvim-nio" },

		opts = {
			layouts = {
				{
					elements = {
						{ id = "breakpoints", size = 0.30 },
						{ id = "scopes", size = 0.35 },
						{ id = "watches", size = 0.35 },
					},
					position = "right",
					size = 0.3,
				},
				{
					elements = {
						{ id = "console", size = 0.5 },
						{ id = "repl", size = 0.5 },
					},
					position = "bottom",
					size = 0.3,
				},
			},
		},

		config = function(_, opts)
			local dapui = require("dapui")
			dapui.setup(opts)

			-- DAP UI Keymaps
			vim.keymap.set("n", "<F12>", function()
				dapui.toggle({ reset = true })
			end, { desc = "DAP: Open/Close UI" })

			vim.keymap.set("n", "<leader>?", function()
				dapui.eval(nil, { enter = true })
			end, { desc = "DAP: Evaluate Variable" })

			-- DAP UI Listeners
			local dap = require("dap")
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

	-- NOTE: DAP Virtual Test
	{
		"theHamsta/nvim-dap-virtual-text",
		lazy = true,

		opts = {
			virt_text_pos = "eol",
		},
	},

	-- NOTE: C/C++ Debugger
	{
		"julianolf/nvim-dap-lldb",
		dependencies = { "nvim-dap" },
		ft = { "c", "cpp" },

		opts = {},
	},

	-- NOTE: Go Debugger
	{
		"leoluz/nvim-dap-go",
		dependencies = { "nvim-dap" },
		ft = { "go" },

		opts = {},
	},
}
