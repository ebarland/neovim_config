return
{
	"artemave/workspace-diagnostics.nvim",
	config = function()
		require("workspace-diagnostics").setup({
			workspace_files = function()
				-- Example: read compile_commands.json and extract file paths
				local json = vim.fn.json_decode(vim.fn.readfile("compile_commands.json"))
				local files = {}
				for _, entry in ipairs(json or {}) do
					table.insert(files, entry.file) -- ensure absolute paths if needed
				end
				return files
			end
		})
	end
}
