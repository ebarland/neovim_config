-- lua/plugins/colorscheme.lua
return
-- {
-- 	"EdenEast/nightfox.nvim",
-- 	config = function()
-- 		require("nightfox").setup({
-- 			options = {
-- 				transparent = true
-- 			}
-- 		})
-- 		vim.cmd("colorscheme dawnfox")
-- 	end
-- }
-- { "catppuccin/nvim", name = "catppuccin", priority = 1000 }

{
	"zenbones-theme/zenbones.nvim",
	-- Optionally install Lush. Allows for more configuration or extending the colorscheme
	-- If you don't want to install lush, make sure to set g:zenbones_compat = 1
	-- In Vim, compat mode is turned on as Lush only works in Neovim.
	dependencies = "rktjmp/lush.nvim",
	lazy = false,
	priority = 1000,
	-- you can set set configuration options here
	config = function()
		
		vim.g.zenbones_lightness = 'dim'
		-- vim.g.zenbones_darken_comments = 45
		vim.cmd.colorscheme('zenbones')
		vim.opt.background='light'
	end
}


-- {
-- 	"vague-theme/vague.nvim",
-- 	lazy = false,  -- make sure we load this during startup if it is your main colorscheme
-- 	priority = 1000, -- make sure to load this before all the other plugins
-- 	config = function()
-- 		-- NOTE: you do not need to call setup if you don't want to.
-- 		require("vague").setup({
-- 			-- optional configuration here
-- 		})
-- 		vim.cmd("colorscheme vague")
-- 	end
-- }

-- {
-- 	'everviolet/nvim',
-- 	name = 'evergarden',
-- 	priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
-- 	opts = {
-- 		theme = {
-- 			variant = 'summer', -- 'winter'|'fall'|'spring'|'summer'
-- 			accent = 'orange',
-- 		},
-- 		editor = {
-- 			transparent_background = false,
-- 			sign = { color = 'none' },
-- 			float = {
-- 				color = 'mantle',
-- 				solid_border = false,
-- 			},
-- 			completion = {
-- 				color = 'surface0',
-- 			},
-- 		},
-- 	},
-- 	config = function()
-- 		require("evergarden").setup({
-- 			-- optional configuration here
-- 		})
-- 		vim.cmd("colorscheme evergarden")
-- 	end
-- 	}

-- lua/plugins/rose-pine.lua
-- {
-- 	"rose-pine/neovim",
-- 	name = "rose-pine",
-- 	config = function()
-- 		vim.cmd("colorscheme rose-pine")
-- 	end
-- }
