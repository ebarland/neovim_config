require("config.lazy")
require("config.keymaps")

vim.lsp.enable('clangd')
vim.lsp.enable('lua_ls')

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

 -- fire once per project root
 vim.api.nvim_create_autocmd('VimEnter', {
 	callback = function()
 		-- Adapt the pattern if you have multiple non–C++ roots
 		if vim.fn.filereadable 'compile_commands.json' == 1 then
 			vim.cmd 'LspStart clangd' -- or your wrapper if you use one
 		end
 	end,
 })

