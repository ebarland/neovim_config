return {
	cmd = { "clangd", '--pch-storage=memory', '-j=8', "--background-index" },
	root_markers = { 'compile_commands.json', 'compile_flags.txt' },
	filetypes = { 'c', 'cpp' },
	flags = {
		debounce_text_changes = 100, -- Faster updates; adjust if too aggressive
	},
	on_attach = function(client, bufnr)
		vim.diagnostic.config({
			update_in_insert = true,
			severity_sort = true,
		})
    	require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
	end,
}
