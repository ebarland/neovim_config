return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/playground", -- so you get :TSHighlightCapturesUnderCursor
	},
	config = function()
		require("nvim-treesitter.configs").setup {
			ensure_installed = {
				-- Front‑end
				"vue", "typescript", "javascript", "html", "css", "scss", "json",
				-- Back‑end
				"c", "cpp", "lua", "python", "rust",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			playground = {
				enable = true,
				updatetime = 25,
				persist_queries = false,
			},
		}
	end,
}
