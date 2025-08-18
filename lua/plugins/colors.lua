-- lua/plugins/colors.lua
return {
	"brenoprata10/nvim-highlight-colors",
	event = { "BufReadPost", "BufNewFile" },
	opts = { render = "virtual" }, -- tiny squares inline
}
