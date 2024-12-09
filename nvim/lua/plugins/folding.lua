return {
	-- NOTE: Code Folding
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },

		opts = {},

		config = function()
			local ufo = require("ufo")

			vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "Folding: Open all folds" })
			vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "Folding: Close all folds" })

			ufo.setup()
		end,
	},

	-- NOTE: Statuscolumn
	{
		"luukvbaal/statuscol.nvim",

		config = function()
			local builtin = require("statuscol.builtin")

			require("statuscol").setup({
				setopt = true,
				segments = {
					-- Signs -> Line Numbers -> Folds -> Empty Space
					{ text = { "%s" } },
					{ text = { builtin.lnumfunc } },
					{ text = { builtin.foldfunc } },
					{ text = { " " } },
				},
			})
		end,
	},
}
