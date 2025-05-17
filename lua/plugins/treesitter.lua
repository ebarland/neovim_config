-- ~/.config/nvim/lua/plugins/treesitter.lua  (on Windows: %USERPROFILE%\AppData\Local\nvim\lua\plugins\treesitter.lua)
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/playground", -- so you get :TSHighlightCapturesUnderCursor
	},
	config = function()
		-- 1) DEBUG PRINT so we know this ran
		vim.schedule(function()
			vim.notify("🧪 Treesitter config loaded!", vim.log.levels.INFO)
		end)

		-- 2) Define a totally new highlight group that's impossible to miss
		vim.api.nvim_set_hl(0, "TestParam", {
			bg = "#FF0000", -- bright red background
			fg = "#FFFFFF", -- white text
			bold = true,
		})

		-- 3) Set up Treesitter, mapping @parameterVariable → TestParam
		require("nvim-treesitter.configs").setup {
			ensure_installed = { "cpp" },
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
				-- **THIS** is the magic line:
				custom_captures = {
					["parameterVariable"] = "TestParam",
				},
			},
			playground = {
				enable = true,
				updatetime = 25,
				persist_queries = false,
			},
		}
	end,
}
