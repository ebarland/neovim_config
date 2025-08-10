-- lua/plugins/undotree.lua
return {
	"mbbill/undotree",
	config = function()
		-- if Windows:
		vim.g.undotree_DiffCommand = "FC"
		vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = 'Toggle undotree' })
	end
}
