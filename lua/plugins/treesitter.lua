-- lua/plugins/treesitter.lua
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup {
			indent = { enable = true, disable = { "c", "cpp" } },
			ensure_installed = {
				-- Front-end
				"vue", "typescript", "javascript", "html", "css", "scss", "json", "tsx",
				-- Back-end
				"c", "cpp", "lua", "python", "rust", "cmake",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		}
	end,
}
