require("config.lazy")
require("config.keymaps")

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
		end
	end,
})

vim.diagnostic.config({
	virtual_lines = {
		current_line = true -- Only show virtual line diagnostics for the current cursor line
	},
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		client.server_capabilities.semanticTokensProvider = nil
	end,
})

-- -- ────────────────────────────────────
-- -- 2. Function that starts or re-uses a client
-- -- ────────────────────────────────────
-- local function start_clangd_for_cwd()
--   -- quick check: is there a CCDB in the *current* dir?
--   if vim.fn.filereadable('compile_commands.json') == 0 then
--     return
--   end
--
--   -- This call is idempotent: vim.lsp.start() re-uses an existing
--   -- client if one with the same {name,root_dir} already lives.
--   vim.lsp.start({
--     name     = 'clangd',              -- MUST match the config name
--     cmd      = { 'clangd' },
--     root_dir = vim.fn.getcwd(),       -- current dir is the project root
--     -- filetypes list is optional here; it matters only for auto-attach
--   })
-- end
--
-- -- ────────────────────────────────────
-- -- 3. Autocmds: fire on startup *and* on every :cd
-- -- ────────────────────────────────────
-- vim.api.nvim_create_autocmd({ 'VimEnter', 'DirChanged' }, {
--   callback = start_clangd_for_cwd,
-- })

-- If you also want clangd to attach automatically
-- the first time a C/C++ buffer opens, keep this:
vim.lsp.enable('clangd')
vim.lsp.enable('lua_ls')
vim.lsp.enable('pyright')

-- Auto-insert + disable line numbers + hide status line if you like
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.cmd("startinsert")    -- Enter insert mode automatically
		vim.wo.number = false     -- Hide line numbers in terminal
		vim.wo.relativenumber = false -- Hide relative line numbers
		vim.o.scrolloff = 0       -- Set scrolloff globally (not buffer/window-local!)
	end,
})
