-- lua/plugins/mason.lua
return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"vue_ls", "vtsls", "clangd", "lua_ls", "pyright", "rust_analyzer", "cmake"
		},
		automatic_enable = false,
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	}
}
