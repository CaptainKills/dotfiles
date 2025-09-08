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

-- INFO: Snippets: Python
return {
	-- stylua: ignore start

	-- Main File Template
	s("main", fmt(
		[[
			def main():
				{}

			if __name__ == "__main__":
				main()
		]], { i(0) })
	),

	-- stylua: ignore end
}
