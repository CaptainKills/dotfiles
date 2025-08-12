return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",

		opts = {
			keep_roots = true,
			link_roots = true,
			link_children = true,

			update_events = "TextChanged,TextChangedI",
			delete_check_events = "TextChanged",

			ext_opts = {
				[require("luasnip.util.types").choiceNode] = {
					active = {
						virt_text = { { "  Choice Node", "Comment" } },
					},
				},
			},
		},

		config = function(_, opts)
			local ls = require("luasnip")
			local loader = require("luasnip.loaders.from_lua")

			ls.setup(opts)
			loader.lazy_load()

			vim.keymap.set({ "i", "s" }, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { desc = "Snippets: Change active choice" })
		end,
	},
}
