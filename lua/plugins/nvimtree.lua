local function my_on_attach(bufnr)
	local api = require "nvim-tree.api"

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	vim.keymap.set('n', '<C-o>', api.tree.change_root_to_node, opts('CD'))
	vim.keymap.set('n', '<C-u>', api.tree.change_root_to_parent, opts('Up'))
end

return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		on_attach = my_on_attach,
		filters = { dotfiles = true },
		view = { width = 40 },
		git = {
			enable = false,
			show_on_dirs = true,
			show_on_open_dirs = true,
			disable_for_dirs = {},
			timeout = 100000,
			cygwin_support = false,
		},
		actions = {
			open_file = {
				resize_window = true,
			},
			change_dir = {
				global = true,
			},
		},
	}
}
