-- lua/plugins/mini.lua
return
{
	"echasnovski/mini.nvim",
	config = function()
		require("mini.statusline").setup()
	end,
	version = false
}
