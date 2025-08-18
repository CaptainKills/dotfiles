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

local math_mode = function()
	local ts = require("nvim-treesitter.ts_utils")
	local node = ts.get_node_at_cursor()

	print("Node: ", node, ", Type: ", node:type(), ", Parent: ", node:parent())
	if node:type() == "math" then
		return true
	end

	local parent = node:parent()
	if parent then
		if parent:type() == "math" then
			return true
		end
	end

	return false
end

return {
	-- stylua: ignore start

	-- Figure Template
	s("fig", fmt(
		[[
			#figure(
				image("{}", width: {}%),
				placement: {},
				caption: [{}],
			) <fig:{}>
			{}
		]], { i(1), i(2, "100"), d(3, placement), i(4), i(5), i(0) })
	),

	-- Table Template
	s("tab", fmt(
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
		]], { d(1, placement), i(2), i(3, "2"), i(5), i(6), i(4), i(0) })
	),

	-- Equation Template
	s("eq", fmt(
		[[
			$ {} $ <eq:{}>
			{}
		]], { i(1), i(2), i(0) })
	),

	-- Inline Math Template
	s({ trig = "$", snippetType = "autosnippet" }, {
		t("$"), i(1), t("$"), i(0),
	}),

	-- Expend _ to _()
	s({ trig = "_", snippetType = "autosnippet", wordTrig = false, condition = math_mode }, {
		t("_("), i(0), t(")"),
	}),

	-- Expand ^ to ^()
	s({ trig = "^", snippetType = "autosnippet", wordTrig = false, condition = math_mode }, {
		t("^("), i(0), t(")"),
	}),

	--stylua: ignore end
}
