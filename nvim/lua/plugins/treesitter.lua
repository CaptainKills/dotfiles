local function treesitter_attach(buf, language)
	-- check if parser exists and load it
	if not vim.treesitter.language.add(language) then
		return
	end

	vim.treesitter.start(buf, language)
end

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",

	opts = {},

	config = function(_, opts)
		local treesitter = require("nvim-treesitter")
		treesitter.setup(opts)

		treesitter.install(opts.ensure_installed)

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf, filetype = args.buf, args.match

				local language = vim.treesitter.language.get_lang(filetype)
				if not language then
					return
				end

				local installed_parsers = require("nvim-treesitter").get_installed("parsers")
				local available_parsers = require("nvim-treesitter").get_available()

				if vim.tbl_contains(installed_parsers, language) then
					-- enable the parser if it is installed
					treesitter_attach(buf, language)
				elseif vim.tbl_contains(available_parsers, language) then
					-- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
					treesitter.install(language):await(function()
						treesitter_attach(buf, language)
					end)
				else
					-- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
					treesitter_attach(buf, language)
				end
			end,
		})
	end,
}
