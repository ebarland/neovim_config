return {
	cmd          = {
		"clangd",
		"--pch-storage=memory",
		"-j=8",
		"--background-index",
	},
	root_markers = { "compile_commands.json", "compile_flags.txt" },
	filetypes    = { "c", "cpp" },
	flags        = {
		debounce_text_changes = 100,
	},
	on_attach    = function(client, bufnr)
		-- ensure full-project scan even if you open files manually
        require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
		vim.diagnostic.config({
			update_in_insert = true,
			severity_sort    = true,
		})
	end,
}
