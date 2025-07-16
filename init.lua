require("config.lazy")
require("config.keymaps")

vim.lsp.enable('clangd', 'lua_ls', 'pyright')

-- vim.api.nvim_create_autocmd('LspAttach', {
-- 	callback = function(ev)
-- 		local client = vim.lsp.get_client_by_id(ev.data.client_id)
-- 		if client:supports_method('textDocument/completion') then
-- 			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
-- 		end
-- 	end,
-- })
--
-- vim.diagnostic.config({
-- 	virtual_lines = {
-- 		current_line = true -- Only show virtual line diagnostics for the current cursor line
-- 	},
-- })
--
-- vim.api.nvim_create_autocmd('LspAttach', {
-- 	callback = function(args)
-- 		local client = vim.lsp.get_client_by_id(args.data.client_id)
-- 		client.server_capabilities.semanticTokensProvider = nil
-- 	end,
-- })
--
-- -- Auto-insert + disable line numbers + hide status line if you like
-- vim.api.nvim_create_autocmd("TermOpen", {
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.cmd("startinsert")    -- Enter insert mode automatically
-- 		vim.wo.number = false     -- Hide line numbers in terminal
-- 		vim.wo.relativenumber = false -- Hide relative line numbers
-- 		vim.o.scrolloff = 0       -- Set scrolloff globally (not buffer/window-local!)
-- 	end,
-- })
