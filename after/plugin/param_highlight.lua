-- after/plugin/param_highlight.lua

vim.api.nvim_set_hl(0, 'ParameterVariable', { fg = '#53F099' })

local ns = vim.api.nvim_create_namespace('ParamHighlight')
local ts_parse = vim.treesitter.query.parse
local qcache = {}

-- Query: capture whole parameter nodes (cpp has optional_parameter_declaration for defaults)
local function get_param_nodes_query(lang)
	local key = "pnodes:" .. lang
	if qcache[key] then return qcache[key] end
	local src
	if lang == 'cpp' then
		src = [[
      (parameter_declaration) @pdecl
      (optional_parameter_declaration) @pdecl
    ]]
	else -- C
		src = [[
      (parameter_declaration) @pdecl
    ]]
	end
	local ok, q = pcall(ts_parse, lang, src)
	if not ok then
		vim.notify('param_highlight: failed to compile param-node query for ' .. lang .. ': ' .. tostring(q),
			vim.log.levels.WARN)
		return nil
	end
	qcache[key] = q
	return q
end

-- Query: any identifier (for usages)
local function get_usage_query(lang)
	local key = "usage:" .. lang
	if qcache[key] then return qcache[key] end
	local ok, q = pcall(ts_parse, lang, [[ (identifier) @id ]])
	if not ok then
		vim.notify('param_highlight: failed to compile usage query for ' .. lang .. ': ' .. tostring(q),
			vim.log.levels.WARN)
		return nil
	end
	qcache[key] = q
	return q
end

-- DFS to find the first identifier node inside a subtree
local function find_ident(node)
	if not node then return nil end
	if node:type() == 'identifier' then return node end
	for i = 0, node:named_child_count() - 1 do
		local child = node:named_child(i)
		local hit = find_ident(child)
		if hit then return hit end
	end
	return nil
end

local function highlight_params(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local ft = vim.bo[bufnr].filetype
	if ft ~= 'c' and ft ~= 'cpp' then return end

	local parser = vim.treesitter.get_parser(bufnr, ft)
	if not parser then return end

	local pnodes_q = get_param_nodes_query(ft)
	local usage_q  = get_usage_query(ft)
	if not pnodes_q or not usage_q then return end

	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	-- 1) Collect (name, function-range); highlight declaration sites
	local defs = {}
	for _, tree in ipairs(parser:parse()) do
		local root = tree:root()
		for id, node in pnodes_q:iter_captures(root, bufnr, 0, -1) do
			if pnodes_q.captures[id] == 'pdecl' then
				-- scope to the enclosing function_definition (covers constructors too)
				local func = node
				while func and func:type() ~= 'function_definition' do
					func = func:parent()
				end
				if func then
					-- grab the declarator field, then the identifier somewhere inside it
					local dec_field = node:field('declarator')
					local dec = dec_field and dec_field[1] or nil
					local name_node = dec and find_ident(dec) or nil
					if name_node then
						local name = vim.treesitter.get_node_text(name_node, bufnr)
						local f_sr, _, f_er, _ = func:range()
						defs[#defs + 1] = { name = name, start_row = f_sr, end_row = f_er }

						-- highlight the name in the signature
						local sr, sc, _, ec = name_node:range()
						vim.api.nvim_buf_add_highlight(bufnr, ns, 'ParameterVariable', sr, sc, ec)
					end
				end
			end
		end
	end

	if #defs == 0 then return end

	-- 2) Highlight usages within the same function ranges
	for _, tree in ipairs(parser:parse()) do
		local root = tree:root()
		for id, node in usage_q:iter_captures(root, bufnr, 0, -1) do
			if usage_q.captures[id] == 'id' then
				local txt = vim.treesitter.get_node_text(node, bufnr)
				local row = select(1, node:range())
				for _, d in ipairs(defs) do
					if txt == d.name and row >= d.start_row and row <= d.end_row then
						local r, c1, _, c2 = node:range()
						vim.api.nvim_buf_add_highlight(bufnr, ns, 'ParameterVariable', r, c1, c2)
						break
					end
				end
			end
		end
	end
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'TextChanged', 'InsertLeave' }, {
	group = vim.api.nvim_create_augroup('ParamHighlightGroup', { clear = true }),
	pattern = { '*.c', '*.cpp', '*.h', '*.hpp' },
	callback = function(ev) highlight_params(ev.buf) end,
})
