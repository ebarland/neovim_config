o = vim.opt

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

o.number = true -- line numbers
o.termguicolors = true

o.backspace = "2"
o.showcmd = true 
o.laststatus = 2 
o.autowrite = true 
o.cursorline = true 
o.autoread = true 

o.ai = true 

o.tabstop = 4                   --  a tab is four spaces
o.softtabstop = 4               -- when hitting <BS>, pretend like a tab is removed, even if spaces
o.shiftwidth = 4                -- number of spaces to use for autoindenting
o.shiftround = true             -- use multiple of shiftwidth when indenting with '<' and '>'
o.autoindent = true             -- always set autoindenting on
o.copyindent = true             -- copy the previous indentation on autoindenting
								-- 
o.showmatch = true              -- set show matching parenthesis
o.smarttab = true               -- insert tabs on the start of a line according to shiftwidth, not tabstop
o.scrolloff = 4                 -- keep 4 lines off the edges of the screen when scrolling


 local tree_status, _ = pcall(require, "nvim-tree")
 if not tree_status then
 	print("nvim-tree not found:", plugin)
 else
	require("nvim-tree").setup()
	local function open_nvim_tree()
		require("nvim-tree.api").tree.open()
	end
	vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
end

local treesitter_status, _ = pcall(require, "nvim-treesitter")
if not treesitter_status then
	print("treesitter not found")
else
	require'nvim-treesitter.configs'.setup {
		-- A list of parser names, or "all" (the five listed parsers should always be installed)
		ensure_installed = { "c", "lua", "cpp", "vim", "vimdoc", "query" },
		-- Install parsers synchronously (only applied to `ensure_installed`)
		sync_install = false,
		-- Automatically install missing parsers when entering buffer
		-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
		auto_install = true,
		-- List of parsers to ignore installing (for "all")
		ignore_install = { "javascript" },
		---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
		-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false
		}
	}
end
