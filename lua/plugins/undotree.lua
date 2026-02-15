-- lua/plugins/undotree.lua
return {
	"mbbill/undotree",
	config = function()
		local platform = require("config.platform")
		-- Windows: use built-in `fc`. Linux/macOS: default `diff` is typically available.
		if platform.is_win then
			vim.g.undotree_DiffCommand = "FC"
		end
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = 'Toggle undotree' })
	end
}
