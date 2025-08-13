return {
	-- NOTE: VimTex LaTeX Editor
	-- Required packages:
	-- * texlive-latex-base		(pdflatex, bibtex)
	-- * texlive-latex-extra
	-- * texlive-bibtex-extra
	-- * texlive-font-utils		(EPS Image Support)
	-- * latexmk				(LaTeX Compiler)
	-- * zathura				(PDF Viewer)
	{
		"lervag/vimtex",
		lazy = false,

		init = function()
			vim.g.vimtex_format_enabled = true
			vim.g.vimtex_fold_enabled = true
			vim.g.vimtex_quickfix_enabled = false

			vim.api.nvim_create_autocmd("BufReadPost", {
				pattern = "*.tex",
				callback = function()
					vim.defer_fn(function()
						-- Reload VimTex for correct folding
						vim.cmd("VimtexReload")
					end, 5000)
				end,
			})
		end,
	},
}
