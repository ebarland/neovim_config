-- %USERPROFILE%\AppData\Local\nvim\after\plugin\param_highlight.lua

--[[
  param_highlight.lua
  ------------------
  This script uses Neovim's Tree-sitter API to highlight function
  parameter names (regular, reference, and pointer) *within their own*
  function bodies in .c, .cpp, .h, and .hpp files. It bypasses the
  built-in highlighter and applies manual extmark highlights for precise
  scoping so that identically named locals outside the parameter scope
  are not colored.

  Key Features:
    1. Captures function parameter names in declarations and records
       their enclosing function ranges.
    2. Captures uses of those parameters only inside the same function.
    3. Supports plain identifiers, references (&), and pointers (*).
    4. Runs automatically on buffer load, changes, and when leaving insert mode.

  Usage:
    - Place this file at:
        %USERPROFILE%\AppData\Local\nvim\after\plugin\param_highlight.lua
    - Restart Neovim.
    - Open a C/C++ source or header (.c/.cpp/.h/.hpp).
    - Parameters and their uses will be colored using the
      `ParameterVariable` highlight group (blue by default).
]]

-- 1) Define the highlight group for parameters.
vim.api.nvim_set_hl(0, 'ParameterVariable', { fg = '#9f96A9' })

-- 2) Create a namespace for our extmark highlights.
local ns = vim.api.nvim_create_namespace('ParamHighlight')

-- 3) Alias the Tree-sitter query parser.
local ts_query = vim.treesitter.query.parse

-- 4) Query to capture parameter declarators (plain, reference, pointer)
local param_query = ts_query('cpp', [[
  (parameter_declaration declarator: (identifier) @param)
  (parameter_declaration declarator: (reference_declarator (identifier) @param))
  (parameter_declaration declarator: (pointer_declarator (identifier) @param))
]])

-- 5) Function to highlight parameters scoped to their own function
local function highlight_params(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	local parser = vim.treesitter.get_parser(bufnr, 'cpp')
	if not parser then return end

	-- Collect parameter definitions with their function ranges
	local paramDefs = {}
	for _, tree in ipairs(parser:parse()) do
		local root = tree:root()
		for id, node in param_query:iter_captures(root, bufnr, 0, -1) do
			if param_query.captures[id] == 'param' then
				local name = vim.treesitter.get_node_text(node, bufnr)
				-- Find enclosing function_definition node
				local func = node
				while func and func:type() ~= 'function_definition' do
					func = func:parent()
				end
				if func then
					-- Extract function start and end rows
					local f_sr, f_sc, f_er, f_ec = func:range()
					table.insert(paramDefs, { name = name, start_row = f_sr, end_row = f_er })
					-- Highlight the declaration site inside the function signature
					local d_sr, d_sc, _, d_ec = node:range()
					vim.api.nvim_buf_add_highlight(bufnr, ns, 'ParameterVariable', d_sr, d_sc, d_ec)
				end
			end
		end
	end

	-- Highlight usages only within their function scopes
	if #paramDefs > 0 then
		local usage_q = ts_query('cpp', [[ (identifier) @id ]])
		for _, tree in ipairs(parser:parse()) do
			local root = tree:root()
			for id, node in usage_q:iter_captures(root, bufnr, 0, -1) do
				if usage_q.captures[id] == 'id' then
					local txt = vim.treesitter.get_node_text(node, bufnr)
					-- Get usage row for scope check
					local u_sr = select(1, node:range())
					for _, def in ipairs(paramDefs) do
						if txt == def.name and u_sr >= def.start_row and u_sr <= def.end_row then
							local u_sr2, u_sc2, _, u_ec2 = node:range()
							-- Note: only start row, start col, and end col are needed
							vim.api.nvim_buf_add_highlight(bufnr, ns, 'ParameterVariable', u_sr2, u_sc2, u_ec2)
							break
						end
					end
				end
			end
		end
	end
end

-- 6) Autocmd: run on load, edits, and leaving Insert mode
vim.api.nvim_create_autocmd({ 'BufReadPost', 'TextChanged', 'InsertLeave' }, {
	group = vim.api.nvim_create_augroup('ParamHighlightGroup', { clear = true }),
	pattern = { '*.c', '*.cpp', '*.h', '*.hpp' },
	callback = function(evt) highlight_params(evt.buf) end,
})
