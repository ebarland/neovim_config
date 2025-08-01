require("config.lazy")
require("config.keymaps")
require("config.lsp")

vim.lsp.enable({
	"vue_ls",     -- Volar 3 / vue_ls
	"vtsls",      -- TypeScript / JavaScript
	"eslint",     -- Linting
	-- Back‑end / system
	"clangd",     -- C / C++
	"lua_ls",     -- Lua (includes vim API)
	"pyright",    -- Python
	"rust_analyzer", -- Rust
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		client.server_capabilities.semanticTokensProvider = nil
		if client:supports_method('textDocument/completion') then
			vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', --[[ 'fuzzy', ]] 'popup' }

			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

			local trigger = function()
				vim.api.nvim_feedkeys(vim.keycode('<C-x><C-o>'), 'n', false)
			end

			vim.keymap.set('i', '<C-j>', trigger, { buffer = ev.buf, silent = true, desc = 'Trigger LSP completion' })
		end
	end,
})

-- Drop this anywhere after your LspAttach block (or inside it with buffer scope)
local function t(keys) return vim.api.nvim_replace_termcodes(keys, true, false, true) end

vim.keymap.set('i', '<Tab>', function()
	if vim.fn.pumvisible() == 1 then
		return t('<C-n>')
	else
		return t('<Tab>') -- keep real tab/indent
	end
end, { expr = true, silent = true, desc = 'PUM next or tab' })

vim.keymap.set('i', '<S-Tab>', function()
	if vim.fn.pumvisible() == 1 then
		return t('<C-p>')
	else
		return t('<S-Tab>')
	end
end, { expr = true, silent = true, desc = 'PUM prev or shift-tab' })

vim.diagnostic.config({
	virtual_lines = {
		current_line = true -- Only show virtual line diagnostics for the current cursor line
	},
})

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.cmd("startinsert")  -- Enter insert mode automatically
		vim.wo.number = false   -- Hide line numbers in terminal
		vim.wo.relativenumber = false -- Hide relative line numbers
		vim.o.scrolloff = 0     -- Set scrolloff globally (not buffer/window-local!)
	end,
})
