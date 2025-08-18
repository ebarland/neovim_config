-- lua/plugins/icons.lua
return {
	"nvim-tree/nvim-web-devicons",
	opts = {
		override_by_extension = {
			css = {
				icon  = "⚙", -- or "⚙", "◆", etc. (plain BMP glyphs are safest)
				color = "#42A5F5",
				name  = "Css",
			},
		},
	}
}
