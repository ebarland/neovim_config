-- lua/plugins/mason.lua
return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"vue_ls", "vtsls", "eslint",
			"clangd", "lua_ls", "pyright", "rust_analyzer",
			"emmet_language_server",
		},
		automatic_enable = false, -- important when using vim.lsp.enable()
	},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
}
