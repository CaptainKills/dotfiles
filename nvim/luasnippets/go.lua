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

-- INFO: Snippets: Go
return {
	-- stylua: ignore start

	-- Main File Template
	s("main", fmta(
		[[
			package main

			import (
				"fmt"
				"log"
				"os"
			)

			func main() {
				<>
			}
		]], { i(0) })
	),

	-- Error Handling Template
	s("err", fmta(
		[[
			if err != nil {
				<>
			}
			<>
		]], { c(1, { t("return err"), t("log.Fatalf(\"Error! %q\\n\", err)"), t("") }), i(0) })
	),

	-- Test File Template
	s("test", fmta(
		[[
			package <>

			import (
				"testing"
				"log"
			)

			func Test<>(t *testing.T) {
				t.Run("<>", func(t *testing.T){
					<>

					got := <>
					want := <>

					if got != want {
						t.Errorf("Test Failed!\n")
					}
				})
				<>
			}

		]], { i(1, "main"), i(2), i(3), i(4), i(5), i(6), i(0) })
	),

	-- Test Function Template
	s("func Test", fmta(
		[[
		func Test<>(t *testing.T) {
			<>
		}
		]], { i(1), i(0) })
	),

	-- Subtest Function Template
	s("t.Run", fmta(
		[[
		t.Run("<>", func (t *testing.T) {
			<>
		})
		]], { i(1), i(0) })
	),

	-- stylua: ignore end
}
