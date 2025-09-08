-- init.lua

-- Load your stuff
require("config.lazy")
require("config.keymaps")
require("config.lsp")
require("config.options") -- ensure your options file loads

-- Diagnostics: keep virtual_lines for the current line
vim.diagnostic.config({
	virtual_lines = { current_line = true },
})

-- Auto-insert mode in terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.cmd("startinsert")
		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.o.scrolloff = 0
	end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
	callback = function()
		vim.cmd("echo ''")
	end,
})
---------------------------------------------------------------------
-- Folding: Treesitter, but only function bodies get folds
---------------------------------------------------------------------

-- Version-safe helper (Neovim 0.10/0.11)
local function set_folds(lang, q)
	local qt = vim.treesitter.query
	if qt and qt.set_query then
		qt.set_query(lang, "folds", q)
	elseif qt and qt.set then
		qt.set(lang, "folds", q)
	else
		-- fallback for older API shapes
		vim.treesitter.query.set(lang, "folds", q)
	end
end

-- C / C++: fold only function bodies (top-level or methods)
local c_cpp_folds = [[
(function_definition
  body: (compound_statement) @fold)
]]
set_folds("c", c_cpp_folds)
set_folds("cpp", c_cpp_folds)

-- Lua: fold only function bodies
-- Supports both global and local functions
local lua_folds = [[
(function_declaration
  body: (block) @fold)
(local_function
  body: (block) @fold)
]]
set_folds("lua", lua_folds)

-- Python: fold only function bodies (sync/async)
local py_folds = [[
(function_definition
  body: (block) @fold)
(async_function_definition
  body: (block) @fold)
]]
set_folds("python", py_folds)

-- Rust: fold only function bodies (incl. methods in impls)
local rs_folds = [[
(function_item
  body: (block) @fold)
]]
set_folds("rust", rs_folds)

-- JavaScript / TypeScript: fold only function-like blocks
-- Includes class methods and arrow functions with block bodies.
local ts_js_folds = [[
(function_declaration
  body: (statement_block) @fold)
(function_expression
  body: (statement_block) @fold)
(method_definition
  body: (statement_block) @fold)
(arrow_function
  body: (statement_block) @fold)
]]
set_folds("javascript", ts_js_folds)
set_folds("typescript", ts_js_folds)

-- Vue: scripts are TS/JS; folding usually handled via injections.
-- If your filetype is "vue", main folding still benefits from TS/JS injections,
-- so no separate "vue" query is typically required.

-- OPTIONAL: C# (uncomment if you want it)
-- local cs_folds = [[
-- (method_declaration      body: (block) @fold)
-- (constructor_declaration body: (block) @fold)
-- (destructor_declaration  body: (block) @fold)
-- ]]
-- set_folds("c_sharp", cs_folds)

-- Recompute & close folds when opening / entering windows
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	callback = function()
		vim.cmd("silent! normal! zx") -- recompute folds after parsers/queries load
		vim.cmd("silent! normal! zM") -- close all (only functions will close)
	end,
})


-- Save folds when leaving buffer
vim.api.nvim_create_autocmd("BufWinLeave", {
	pattern = "*",
	callback = function()
		vim.cmd("silent! mkview")
	end,
})

-- Restore folds when entering buffer
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	callback = function()
		vim.cmd("silent! loadview")
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "cmake",
	callback = function()
		vim.keymap.set("n", "<leader>fd", function()
			local formatted = vim.fn.system(
				{ "C:/Users/Egil/AppData/Roaming/Python/Python313/Scripts/cmake-format.exe", vim.fn.expand("%:p") }
			)
			if vim.v.shell_error == 0 then
				local curpos = vim.api.nvim_win_get_cursor(0)
				vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(formatted, "\n"))
				vim.api.nvim_win_set_cursor(0, curpos)
			else
				print("cmake-format error: " .. formatted)
			end
		end, { buffer = true, desc = "Format CMake file" })
	end,
})

-- QoL mappings
vim.keymap.set("n", "<leader>zf", function()
	vim.cmd("silent! normal! zx | silent! normal! zM")
end, { desc = "Recompute + close function folds" })

vim.keymap.set("n", "<leader>zo", function()
	vim.wo.foldlevel = 99
end, { desc = "Open all folds" })

-- Auto-warm <cwd>/src once per session (when clangd first attaches to a C/C++ buffer).
-- Also exposes :ClangdWarm to run manually, and :ClangdWarmReset to clear the "done" state.
do
	local config = {
		batch    = 16, -- files per tick
		delay_ms = 50, -- pause between batches
		exts     = { "c", "cc", "cxx", "cpp", "h", "hh", "hpp", "hxx" },
		exclude  = { "build", ".git", "third_party", "extern" },
		subdir   = "src", -- warmed directory under cwd
	}

	local function pesc(s) return (s:gsub("([^%w])", "%%%1")) end

	local function in_excluded_dir(p)
		for _, name in ipairs(config.exclude) do
			local pat = ("[\\/]%s[\\/]"):format(name == ".git" and "%%.git" or pesc(name))
			if p:find(pat) then return true end
		end
		return false
	end

	local function collect_files(dir)
		local files, seen = {}, {}
		for _, ext in ipairs(config.exts) do
			local pat = ("**/*.%s"):format(ext)
			for _, p in ipairs(vim.fn.globpath(dir, pat, true, true)) do
				if not in_excluded_dir(p) and not seen[p] then
					seen[p] = true
					table.insert(files, p)
				end
			end
		end
		return files
	end

	local function warm_dir(dir, on_done)
		dir = vim.fs.normalize(dir)
		if vim.fn.isdirectory(dir) ~= 1 then
			vim.notify(("ClangdWarm: directory not found: %s"):format(dir), vim.log.levels.ERROR)
			if on_done then on_done(false) end
			return
		end
		local files = collect_files(dir)
		if #files == 0 then
			vim.notify(("ClangdWarm: no C/C++ files under %s"):format(dir), vim.log.levels.WARN)
			if on_done then on_done(false) end
			return
		end

		vim.notify(("ClangdWarm: warming %d files under %s"):format(#files, dir))
		local i, batch = 1, config.batch
		local function step()
			local n = 0
			while i <= #files and n < batch do
				local b = vim.fn.bufadd(files[i])
				vim.fn.bufload(b) -- triggers LSP didOpen -> clangd parses & caches
				i, n = i + 1, n + 1
			end
			if i <= #files then
				vim.defer_fn(step, config.delay_ms)
			else
				vim.notify("ClangdWarm: done.")
				if on_done then on_done(true) end
			end
		end
		step()
	end

	-- Manual commands
	vim.api.nvim_create_user_command("ClangdWarm", function()
		local cwd = vim.fs.normalize(vim.fn.getcwd())
		warm_dir(vim.fs.joinpath(cwd, config.subdir))
	end, {})

	vim.api.nvim_create_user_command("ClangdWarmReset", function()
		vim.g.clangd_warm_done_dirs = {}
		vim.g.clangd_warm_running = false
		vim.notify("ClangdWarm: session state reset.")
	end, {})

	-- Autocmd: run once per cwd when clangd first attaches to a C/C++ buffer
	local grp = vim.api.nvim_create_augroup("ClangdWarmAuto", { clear = true })
	vim.api.nvim_create_autocmd("LspAttach", {
		group = grp,
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if not client or client.name ~= "clangd" then return end
			local ft = vim.bo[args.buf].filetype
			if ft ~= "c" and ft ~= "cpp" then return end

			local cwd = vim.fs.normalize(vim.fn.getcwd())
			vim.g.clangd_warm_done_dirs = vim.g.clangd_warm_done_dirs or {}
			if vim.g.clangd_warm_running or vim.g.clangd_warm_done_dirs[cwd] then return end

			vim.g.clangd_warm_running = true
			-- small delay so clangd is fully ready
			vim.defer_fn(function()
				warm_dir(vim.fs.joinpath(cwd, config.subdir), function(ok)
					vim.g.clangd_warm_done_dirs[cwd] = true
					vim.g.clangd_warm_running = false
				end)
			end, 200)
		end,
	})
end
