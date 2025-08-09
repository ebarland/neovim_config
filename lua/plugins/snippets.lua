-- lua/plugins/snippets.lua
return {
	-- {
	-- 	"L3MON4D3/LuaSnip",
	-- 	version = "v2.*",
	-- 	config = function()
	-- 		local ls = require("luasnip")
	-- 		ls.config.set_config({
	-- 			history = true,
	-- 			updateevents = "TextChanged,TextChangedI",
	-- 			enable_autosnippets = true,
	-- 		})
	--
	-- 		-- Jump through tabstops
	-- 		vim.keymap.set({ "i", "s" }, "<C-j>", function() ls.jump(1) end, { silent = true })
	-- 		vim.keymap.set({ "i", "s" }, "<C-k>", function() ls.jump(-1) end, { silent = true })
	--
	-- 		-- Make HTML-scoped snippets visible inside <template> of .vue
	-- 		ls.filetype_extend("vue", { "html" })
	-- 		-- (Optional) See JS/TS snippets in <script> blocks too
	-- 		ls.filetype_extend("vue", { "javascript", "typescript" })
	--
	-- 		-- Load VSCode-style snippets
	-- 		-- require("luasnip.loaders.from_vscode").lazy_load()         -- friendly-snippets
	-- 		-- require("luasnip.loaders.from_vscode").lazy_load({
	-- 		-- 	paths = { vim.fn.stdpath("data") .. "/lazy/vue-vscode-snippets" }, -- sdras pack
	-- 		-- })
	-- 	end,
	-- },

	-- Community mega-pack (includes lots of HTML/JS/TS snippets)
	-- { "rafamadriz/friendly-snippets" },

	-- {
	-- 	"sdras/vue-vscode-snippets",
	-- 	name = "vue-vscode-snippets",
	-- 	lazy = true, -- just provides JSON for the loader above
	-- },
}
