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

-- INFO: Snippets: LaTeX
return {
	-- Report Template
	s(
		"report",
		fmta(
			[[
			\documentclass[11pt, a4paper]{article}
			\usepackage[margin=2.5cm]{geometry}
			\usepackage{cite}
			\usepackage{graphicx}
			\usepackage{amsmath}
			\usepackage{amssymb}
			\usepackage{comment}
			\usepackage{balance}
			\usepackage{hyperref}

			\title{<1>}
			\author{<2>}
			\date{<3>}

			\begin{document}

			\maketitle

			\section{Introduction}
			<4>

			\end{document}
		]],
			{ i(1), i(2), i(3), i(0) }
		)
	),

	-- Being/End Template
	s(
		"\\begin",
		fmta(
			[[
			\begin{<1>}
				<2>
			\end{<3>}
		]],
			{ i(1), i(0), rep(1) }
		)
	),

	-- Figure Template
	s(
		"fig",
		fmta(
			[[
			\begin{figure}<1>
				\centering
				\includegraphics[scale=<2>]{<5>}
				\caption{<3>}
				\label{fig:<4>}
			\end{figure}
			<6>
		]],
			{ c(1, { t(""), t("[ht!]") }), i(2, "1.0"), i(3), i(4), i(5), i(0) }
		)
	),

	-- Table Template
	s(
		"tab",
		fmta(
			[[
			\begin{table}
				\centering
				\caption{<1>}
				\begin{tabular}{<2>}
					<4>
				\end{tabular}
				\label{tab:<3>}
			\end{table}
			<5>
	]],
			{ i(1), c(2, { t("|l|l|"), t("|c|c|"), t("|r|r|") }), i(3), i(4), i(0) }
		)
	),

	-- Equation Template
	s(
		"eq",
		fmta(
			[[
			\begin{equation}
				<>
			\end{equation}
	]],
			{ i(0) }
		)
	),

	-- List Template
	s(
		"list",
		fmta(
			[[
			\begin{<1>}
				\item <3>
			\end{<2>}
			<4>
	]],
			{ c(1, { t("enumerate"), t("itemize") }), rep(1), i(2), i(0) }
		)
	),
}
