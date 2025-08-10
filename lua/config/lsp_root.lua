-- lua/config/lsp_root.lua
local util = require('lspconfig.util')
local fs   = vim.fs
local uv   = vim.uv                   -- libuv bindings
local sep  = package.config:sub(1, 1) -- "\" on Windows, "/" on POSIX

---@param bufnr   integer
---@param on_dir  fun(root?: string)
return function(bufnr, on_dir)
	-- A. Ignore buffers with no name (first buffer, :help, etc.)
	local fname = vim.api.nvim_buf_get_name(bufnr)
	if fname == '' then return end

	-- B. Project markers (never inside node_modules)
	local root = util.root_pattern(
		'tsconfig.json', 'jsconfig.json',
		'package.json', '.git'
	)(fname) or fs.dirname(fname)

	-- C. Collapse node_modules workspaces
	root = root:gsub('[\\/][Nn]ode_modules[\\/].*$', '')

	-- D. Normalise slashes so fs_realpath() works
	if sep == '\\' then
		root = root:gsub('/', '\\')
	else
		root = root:gsub('\\', '/')
	end

	root = uv.fs_realpath(root) or root -- canonical path

	-- E. Tell Neovim to activate the server for this buffer
	on_dir(root)
end
