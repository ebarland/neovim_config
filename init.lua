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
