-- lua/plugins/workspace-diagnostics.lua
return {
	"artemave/workspace-diagnostics.nvim",
	-- load only for C / C++
	ft = { "c", "cpp" },

	config = function()
		require("workspace-diagnostics").setup({
			workspace_files = function()
				local cwd = vim.fn.getcwd()

				-- Normalise paths to forward slashes for reliable prefix checks
				local function norm(path)
					return path:gsub("\\", "/")
				end

				local src_prefix = norm(cwd .. "/src/") -- absolute, trailing slash

				-- Add a file once, if it lives under src/
				local function add(list, path, seen)
					path = norm(path)
					if path:sub(1, #src_prefix) == src_prefix and not seen[path] then
						table.insert(list, path)
						seen[path] = true
					end
				end

				local files, seen = {}, {}

				-------------------------------------------------------------------
				-- 1. Pull *.cpp / *.c files from compile_commands.json
				-------------------------------------------------------------------
				local compdb = vim.fn.findfile("compile_commands.json", cwd .. ";")
				if compdb ~= "" then
					local ok, db = pcall(
						vim.fn.json_decode,
						table.concat(vim.fn.readfile(compdb), "\n")
					)
					if ok then
						for _, entry in ipairs(db) do
							add(files, entry.file, seen)
						end
					end
				end

				-------------------------------------------------------------------
				-- 2. Add every header tracked in Git under src/
				-------------------------------------------------------------------
				local header_glob = vim.split(
					vim.fn.system("git -C " .. cwd .. " ls-files src | " ..
						"grep -E '\\.(h|hpp|hh|tpp)$'"),
					"\n",
					{ trimempty = true }
				)
				for _, rel in ipairs(header_glob) do
					add(files, cwd .. "/" .. rel, seen)
				end

				return files
			end,
		})
	end,
}
