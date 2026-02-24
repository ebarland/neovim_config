-- after/plugin/param_highlight.lua

local ns = vim.api.nvim_create_namespace('ParamHighlight')
local ts_parse = vim.treesitter.query.parse
local qcache = {}

local MAX_SHADOW = 3

local function set_param_hl()
	local dark = vim.o.background == 'dark'
	vim.api.nvim_set_hl(0, 'ParameterVariable', { fg = dark and '#53F099' or '#6959f1' })
	local shadow = dark
		and { '#7EC8F2', '#C49BF5', '#F5CB7A' }
		or  { '#1778C9', '#C4268A', '#B37D00' }
	for i, color in ipairs(shadow) do
		vim.api.nvim_set_hl(0, 'ParameterShadow' .. i, { fg = color })
	end
end
set_param_hl()

vim.api.nvim_create_autocmd('ColorScheme', {
	group = vim.api.nvim_create_augroup('ParamHighlightColors', { clear = true }),
	callback = set_param_hl,
})

local function depth_hl(depth)
	if depth == 0 then return 'ParameterVariable' end
	return 'ParameterShadow' .. math.min(depth, MAX_SHADOW)
end

---------------------------------------------------------------------------
-- Treesitter query helpers
---------------------------------------------------------------------------

local function get_param_query(lang)
	local key = 'param:' .. lang
	if qcache[key] then return qcache[key] end
	local src
	if lang == 'cpp' then
		src = [[
			(parameter_declaration) @pdecl
			(optional_parameter_declaration) @pdecl
		]]
	elseif lang == 'rust' then
		src = [[ (parameter) @pdecl ]]
	else
		src = [[ (parameter_declaration) @pdecl ]]
	end
	local ok, q = pcall(ts_parse, lang, src)
	if not ok then return nil end
	qcache[key] = q
	return q
end

local function get_let_query(lang)
	if lang ~= 'rust' then return nil end
	local key = 'let:' .. lang
	if qcache[key] then return qcache[key] end
	local ok, q = pcall(ts_parse, lang, [[ (let_declaration) @let_decl ]])
	if not ok then return nil end
	qcache[key] = q
	return q
end

local function get_ident_query(lang)
	local key = 'ident:' .. lang
	if qcache[key] then return qcache[key] end
	local ok, q = pcall(ts_parse, lang, [[ (identifier) @id ]])
	if not ok then return nil end
	qcache[key] = q
	return q
end

---------------------------------------------------------------------------
-- Node helpers
---------------------------------------------------------------------------

local func_scope_types = {
	function_definition = true, -- C/C++
	function_item       = true, -- Rust fn
	closure_expression  = true, -- Rust closures
}

local function find_ident(node)
	if not node then return nil end
	if node:type() == 'identifier' then return node end
	for i = 0, node:named_child_count() - 1 do
		local hit = find_ident(node:named_child(i))
		if hit then return hit end
	end
	return nil
end

local function enclosing_func(node)
	local cur = node:parent()
	while cur and not func_scope_types[cur:type()] do
		cur = cur:parent()
	end
	return cur
end

local function func_key(func_node)
	local sr, sc, er, ec = func_node:range()
	return sr .. ':' .. sc .. ':' .. er .. ':' .. ec
end

local function pos_le(r1, c1, r2, c2)
	return r1 < r2 or (r1 == r2 and c1 <= c2)
end

---------------------------------------------------------------------------
-- Main highlight logic
--
-- For each function we build a "binding chain" per parameter name:
--   depth 0  = the parameter declaration (effective from function start)
--   depth N  = the Nth let-shadow        (effective from end of its let_declaration)
--
-- A let_declaration like `let input = input + 1;` has two identifiers:
--   LHS (pattern) → the NEW binding, matched by decl_id
--   RHS (value)   → the OLD binding, because the new binding's effective
--                    position is at the END of the let_declaration, which is
--                    after the RHS in source order.
--
-- Limitation: block-scoped shadows (e.g. `{ let x = ..; }`) don't revert
-- depth when the block ends. Sequential shadowing in the same block (the
-- common Rust pattern) works correctly.
---------------------------------------------------------------------------

local function highlight_params(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype
	if ft ~= 'c' and ft ~= 'cpp' and ft ~= 'rust' then return end

	local ok, parser = pcall(vim.treesitter.get_parser, bufnr, ft)
	if not ok or not parser then return end

	local param_q = get_param_query(ft)
	local ident_q = get_ident_query(ft)
	if not param_q or not ident_q then return end
	local let_q = get_let_query(ft)

	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	-- funcs[key].bindings[name] = { {depth, decl_id, eff_row, eff_col}, … }
	local funcs = {}

	-- Phase 1: parameter bindings (depth 0)
	for _, tree in ipairs(parser:parse()) do
		local root = tree:root()
		for id, node in param_q:iter_captures(root, bufnr, 0, -1) do
			if param_q.captures[id] == 'pdecl' then
				local func = enclosing_func(node)
				if func then
					local name_field = ft == 'rust' and 'pattern' or 'declarator'
					local dec_field = node:field(name_field)
					local dec = dec_field and dec_field[1] or nil
					local name_node = dec and find_ident(dec) or nil
					if name_node then
						local name = vim.treesitter.get_node_text(name_node, bufnr)
						local fk = func_key(func)
						if not funcs[fk] then funcs[fk] = { bindings = {} } end
						local b = funcs[fk].bindings
						if not b[name] then b[name] = {} end
						local f_sr, f_sc = func:range()
						b[name][#b[name] + 1] = {
							depth   = 0,
							decl_id = name_node:id(),
							eff_row = f_sr,
							eff_col = f_sc,
						}
					end
				end
			end
		end
	end

	-- Phase 2: let-shadows (Rust only, adds depth 1, 2, … to existing chains)
	if let_q then
		for _, tree in ipairs(parser:parse()) do
			local root = tree:root()
			for id, node in let_q:iter_captures(root, bufnr, 0, -1) do
				if let_q.captures[id] == 'let_decl' then
					local func = enclosing_func(node)
					if func then
						local fk = func_key(func)
						local fdata = funcs[fk]
						if fdata then
							local pat_field = node:field('pattern')
							local pat = pat_field and pat_field[1] or nil
							local name_node = pat and find_ident(pat) or nil
							if name_node then
								local name = vim.treesitter.get_node_text(name_node, bufnr)
								local chain = fdata.bindings[name]
								if chain then
									local _, _, let_er, let_ec = node:range()
									chain[#chain + 1] = {
										depth   = chain[#chain].depth + 1,
										decl_id = name_node:id(),
										eff_row = let_er,
										eff_col = let_ec,
									}
								end
							end
						end
					end
				end
			end
		end
	end

	-- Phase 3: color every identifier that belongs to a binding chain
	for _, tree in ipairs(parser:parse()) do
		local root = tree:root()
		for id, node in ident_q:iter_captures(root, bufnr, 0, -1) do
			if ident_q.captures[id] == 'id' then
				local func = enclosing_func(node)
				if func then
					local fdata = funcs[func_key(func)]
					if fdata then
						local txt = vim.treesitter.get_node_text(node, bufnr)
						local chain = fdata.bindings[txt]
						if chain then
							local row, col = node:range()
							local nid = node:id()
							local depth = nil

							for _, b in ipairs(chain) do
								if b.decl_id == nid then
									depth = b.depth
									break
								end
							end

							if not depth then
								for i = #chain, 1, -1 do
									local b = chain[i]
									if pos_le(b.eff_row, b.eff_col, row, col) then
										depth = b.depth
										break
									end
								end
							end

							if depth then
								local r, c1, _, c2 = node:range()
								vim.api.nvim_buf_add_highlight(bufnr, ns, depth_hl(depth), r, c1, c2)
							end
						end
					end
				end
			end
		end
	end
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'TextChanged', 'InsertLeave' }, {
	group = vim.api.nvim_create_augroup('ParamHighlightGroup', { clear = true }),
	pattern = { '*.c', '*.cpp', '*.h', '*.hpp', '*.rs' },
	callback = function(ev) highlight_params(ev.buf) end,
})
