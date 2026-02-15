-- lua/plugins/nvimtree.lua
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
	-- dependencies = {
	-- 	"nvim-tree/nvim-web-devicons",
	-- },
	opts = {
		on_attach = my_on_attach,
		-- Hide dotfiles and the `build` directory to prevent scanning
		filters = {
			dotfiles = true,
			custom = { "build" },
			exclude = { "build.bat", "build_with_tests.bat", "rebuild.bat", "build_output.log" }
		},
		view = {
			width = 40,
		},
		-- Disable filesystem watchers to avoid massive rescans on build
		filesystem_watchers = {
			-- enable = false,
			debounce_delay = 50,
			ignore_dirs = {
				"/.ccls-cache",
				"/build",
				"/node_modules",
				"/target",
			},
		},
		update_focused_file = {
			enable = false,
			update_cwd = false,
		},
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
		sync_root_with_cwd = true,
		respect_buf_cwd = true,
	},
}
