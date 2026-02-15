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
			},
			highlight = { enable = true, additional_vim_regex_highlighting = false },
		}
	end,
}


-- -- lua/plugins/treesitter.lua
-- return {
-- 	"nvim-treesitter/nvim-treesitter",
-- 	lazy = false, -- main branch: does not support lazy-loading
-- 	build = ":TSUpdate",
-- 	config = function()
-- 		local ts = require("nvim-treesitter")
--
-- 		-- Keep parsers/queries in a predictable, cross-platform location
-- 		ts.setup({
-- 			install_dir = vim.fn.stdpath("data") .. "/site",
-- 		})
--
-- 		-- Install parsers (async). :TSUpdate (above) keeps them in sync.
-- 		ts.install({
-- 			-- Front-end
-- 			"vue", "typescript", "javascript", "html", "css", "scss", "json", "tsx",
-- 			-- Back-end
-- 			"c", "cpp", "lua", "python", "rust", "cmake",
-- 		})
--
-- 		-- Enable highlighting via Neovim (main branch expects this)
-- 		vim.api.nvim_create_autocmd("FileType", {
-- 			callback = function(ev)
-- 				-- highlight
-- 				pcall(vim.treesitter.start, ev.buf)
--
-- 				-- indent (experimental), but disable for c/cpp like you had before
-- 				local ft = vim.bo[ev.buf].filetype
-- 				if ft ~= "c" and ft ~= "cpp" then
-- 					vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
-- 				end
-- 			end,
-- 		})
-- 	end,
-- }
