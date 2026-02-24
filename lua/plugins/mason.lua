-- lua/plugins/mason.lua
return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = (function()
			local platform = require("config.platform")
			-- Keep Linux servers light: Python-first.
			if platform.is_win then
				return {
					"vue_ls", "vtsls", "clangd", "lua_ls", "pyright", "cmake",
					"eslint", "tailwindcss",
				}
			end
			return { "lua_ls", "pyright" }
		end)(),
		automatic_enable = false,
	},
	dependencies = {
		{
			"mason-org/mason.nvim",
			opts = {
				ensure_installed = (function()
					local platform = require("config.platform")
					if platform.is_win then
						return { "prettierd", "eslint_d", "codelldb" }
					end
					-- Python-focused tools (works well on Ubuntu).
					return { "ruff", "black", "debugpy" }
				end)(),
			}
		},
		"neovim/nvim-lspconfig",
	}
}
