return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-neotest/nvim-nio",
		-- "williamboman/mason.nvim",
		-- "WhoIsSethDaniel/mason-tool-installer.nvim",
		-- "jay-babu/mason-nvim-dap.nvim",
	},

	opts = {},

	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local daptext = require("nvim-dap-virtual-text")

		-- NOTE: DAP Keymaps
		vim.keymap.set("n", "<F1>", dap.continue, { desc = "DAP: Start Debugger" })
		vim.keymap.set("n", "<F2>", dap.step_into, { desc = "DAP: Step Into" })
		vim.keymap.set("n", "<F3>", dap.step_over, { desc = "DAP: Step Over" })
		vim.keymap.set("n", "<F4>", dap.step_out, { desc = "DAP: Step Out" })
		vim.keymap.set("n", "<F5>", dap.step_back, { desc = "DAP Step Back" })
		vim.keymap.set("n", "<F12>", dap.restart, { desc = "DAP: Restart Debugger" })
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>?", function()
			dapui.eval(nil, { enter = true })
		end, { desc = "DAP: Evaluate Variable" })

		-- NOTE: DAP UI
		dapui.setup()
		daptext.setup()

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			-- dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
		-- 	dapui.close()
		end

		dap.configurations.java = {
			{
				name = "Debug Application",
				type = "java",
				request = "launch",
			},
		}
	end,
}
