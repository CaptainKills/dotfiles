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
local get_file_name = function()
	local path_name = vim.api.nvim_buf_get_name(0)
	local buf_name = vim.fs.basename(path_name)

	local file_name = vim.split(buf_name, ".", { plain = true })[1]
	file_name = string.upper(file_name)

	return sn(nil, t(file_name))
end

-- INFO: Snippets: C
return {
	-- Header File Template
	s(
		"header",
		fmt(
			[[
		#ifndef __{}_H
		#define __{}_H

		{}

		#endif // __{}_H
	]],
			{ d(1, get_file_name), rep(1), i(0), rep(1) }
		)
	),

	-- Main File Template
	s(
		"main",
		fmt(
			[[
		#include <stdio.h>
		#include <stdlib.h>

		int main({}) {{
			{}
			return 0;
		}}
		]],
			{ c(1, { t("void"), t("int argc, char* argv[]") }), i(0) }
		)
	),
}
