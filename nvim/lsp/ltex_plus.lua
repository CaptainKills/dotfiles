local language_id_mapping = {
	bib = "bibtex",
	pandoc = "markdown",
	plaintex = "tex",
	rnoweb = "rsweave",
	rst = "restructuredtext",
	tex = "latex",
	text = "plaintext",
}

local function get_language_id(_, filetype)
	return language_id_mapping[filetype] or filetype
end

return {
	cmd = { "ltex-ls-plus" },
	filetypes = { "bib", "markdown", "typst" },
	root_markers = { ".git" },
	get_language_id = get_language_id,

	settings = {
		ltex = {
			language = "en-GB",
			checkFrequency = "save",

			disabledRules = {
				["en-GB"] = { "OXFORD_SPELLING_Z_NOT_S" },
			},

			additionalRules = {
				motherTongue = "nl",
			},
		},
	},
}
