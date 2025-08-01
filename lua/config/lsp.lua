vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			diagnostics =
			{
				globals = { "vim" }
			}
		}
	}
})

vim.lsp.config('clangd', {
	on_attach = function(client, bufnr)
		-- ensure full-project scan even if you open files manually
		require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
		vim.diagnostic.config({
			update_in_insert = true,
			severity_sort    = true,
		})
	end,
})
