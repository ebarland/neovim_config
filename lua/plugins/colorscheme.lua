return
-- {
-- 	"EdenEast/nightfox.nvim",
-- 	config = function()
-- 		require("nightfox").setup({
-- 			options = {
-- 				transparent = false
-- 			}
-- 		})
-- 		vim.cmd("colorscheme terafox")
-- 	end
-- }
{
	'sainnhe/gruvbox-material',
	lazy = false,
	priority = 1000,
	config = function()
		-- Optionally configure and load the colorscheme
		-- directly inside the plugin declaration.
		-- vim.g.gruvbox_material_enable_italic = true
		vim.cmd.colorscheme('gruvbox-material')
	end
}
