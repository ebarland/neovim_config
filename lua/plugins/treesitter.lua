-- lua/plugins/treesitter.lua
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup {
			indent = { enable = true, disable = { "c", "cpp" } },
			ensure_installed = {
				"vue", "typescript", "javascript", "html", "css", "scss", "json", "tsx",
				"c", "cpp", "lua", "python", "rust", "cmake",
				"toml", "glsl",
			},
			highlight = { enable = true },
		}
	end,
}
