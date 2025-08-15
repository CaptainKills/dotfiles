local ls = require("luasnip")

-- Shorthand Snippet Variables
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

-- Shorthand Snippet Functions
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta

-- Helper Functions
local placement = function()
	return sn(nil, c(1, { t("none"), t("auto"), t("top"), t("bottom") }))
end

return {
	-- Figure Template
	s(
		"fig",
		fmt(
			[[
			#figure(
				image("{}"),
				placement: {},
				caption: [{}],
			) <fig:{}>
			{}
		]],
			{ i(1), d(2, placement), i(3), i(4), i(0) }
		)
	),

	-- Table Template
	s(
		"tab",
		fmt(
			[[
			#figure(
				placement: {},
				caption: [{}],

				table(
					columns: {},

					table.header([*{}*], [**]),
					[{}], []
				)
			) <tab:{}>
			{}
		]],
			{ d(1, placement), i(2), i(3, "2"), i(5), i(6), i(4), i(0) }
		)
	),
}
