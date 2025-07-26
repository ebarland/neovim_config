vim.keymap.set('n', '<leader>e', "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local function open_tree_at(dir)
	local escaped = vim.fn.fnameescape(dir)
	vim.cmd("cd " .. escaped)
	require("nvim-tree.api").tree.close()
	require("nvim-tree.api").tree.open({ path = dir, update_root = true })
end

vim.keymap.set("n", "<leader>cc", function() open_tree_at(vim.fn.stdpath("config")) end,
	{ silent = true, desc = "Open NvimTree at Neovim config" })
vim.keymap.set("n", "<leader>cd", function() open_tree_at("C:\\Development\\Git\\Private") end,
	{ silent = true, desc = "Open NvimTree at Dev folder" })
vim.keymap.set("n", "<leader>bd", ":wa<CR>:! .\\scripts\\compile.bat Debug<CR>",
	{ desc = "runs compile.bat with Debug config" })
vim.keymap.set("n", "<leader>br", ":wa<CR>:! .\\scripts\\compile.bat Release<CR>",
	{ desc = "runs compile.bat with Release config" })
vim.keymap.set("n", "<leader>bed", ":wa<CR>:! .\\scripts\\recompile.bat Debug<CR>",
	{ desc = "runs recompile.bat with Debug config" })
vim.keymap.set("n", "<leader>ber", ":wa<CR>:! .\\scripts\\recompile.bat Release<CR>",
	{ desc = "runs recompile.bat with Release config" })
vim.keymap.set("n", "<leader>rr", ":! .\\scripts\\run.bat<CR>:edit output.log<CR>", { desc = "runs and opens log" })
vim.keymap.set("n", "<leader>rd", ":! .\\scripts\\debug.bat<CR>", { desc = "runs debug.bat" })
vim.keymap.set("n", "<leader>rt", ":! .\\scripts\\test.bat<CR>", { desc = "runs test.bat" })
vim.keymap.set("n", "<leader>rft", ":! .\\scripts\\test_failed.bat<CR>", { desc = "runs test_failed.bat" })
vim.keymap.set("n", "<leader>gl", "<cmd> :lua require('glslView').glslView({'-w', '128', '-h', '256'}) <CR>",
	{ desc = "Toggle GLSL Viewer" })

-- after your plugin loader...
vim.keymap.set("n", "<leader>dd", "<cmd>Bdelete<CR>", { desc = "Buffer delete (keep layout)" })
vim.keymap.set("n", "<leader>dD", "<cmd>Bwipeout<CR>", { desc = "Buffer wipeout (keep layout)" })

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Remap Ctrl + hjkl for window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Delete word before cursor in Insert mode
vim.keymap.set("i", "<C-H>", "<C-w>", { noremap = true })
vim.keymap.set("c", "<C-h>", "<C-w>", { noremap = true })

-- LSP
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set("v", "<leader>fl", vim.lsp.buf.format, { remap = false })
vim.keymap.set("n", "<leader>fd", vim.lsp.buf.format, { remap = false })

vim.keymap.set("n", "<leader>ne", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>pe", vim.diagnostic.goto_prev)

-- Bufferline
vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })

-- Correct common command typos caused by holding Shift
vim.cmd.cnoreabbrev("Wq wq")
vim.cmd.cnoreabbrev("WQ wq")
vim.cmd.cnoreabbrev("Wa wa")
vim.cmd.cnoreabbrev("WA wa")
vim.cmd.cnoreabbrev("Wqa wqa")
vim.cmd.cnoreabbrev("WQA wqa")
vim.cmd.cnoreabbrev("Q q")
vim.cmd.cnoreabbrev("Qa qa")
vim.cmd.cnoreabbrev("QA qa")
vim.cmd.cnoreabbrev("W w")

vim.api.nvim_set_keymap('n', '<space>x', '', {
	noremap = true,
	callback = function()
		for _, client in ipairs(vim.lsp.buf_get_clients()) do
			print('hello mother')
			require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
		end
	end
})
