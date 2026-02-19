-- lua/config/keymaps.lua

local platform = require("config.platform")

-- Detect gtest macro on a line and return a ctest -R friendly filter
-- Supports TEST, TEST_F, TEST_P, TYPED_TEST
local function gtest_filter_from_line(line)
	-- Trim
	line = line or ""
	-- Patterns to try in order
	local patterns = {
		"^%s*TEST%s*%(%s*([%w_]+)%s*,%s*([%w_]+)%s*%)",
		"^%s*TEST_F%s*%(%s*([%w_]+)%s*,%s*([%w_]+)%s*%)",
		"^%s*TEST_P%s*%(%s*([%w_]+)%s*,%s*([%w_]+)%s*%)",
		"^%s*TYPED_TEST%s*%(%s*([%w_]+)%s*,%s*([%w_]+)%s*%)",
	}
	local suite, name
	for _, pat in ipairs(patterns) do
		suite, name = string.match(line, pat)
		if suite and name then break end
	end
	if not (suite and name) then return nil end

	-- Build "Suite.Test" but escape for ctest -R (regex)
	local raw = suite .. "." .. name
	local function escape_regex(s)
		-- Escape characters meaningful in CTest's regex: . ^ $ * + ? ( ) [ ] { } | \
		return (s:gsub("([%.%^%$%*%+%?%(%)%[%]%{%}%|%\\])", "\\%1"))
	end
	return escape_regex(raw)
end

-- If in visual mode, get the first selected line; otherwise use current line
local function current_or_visual_line()
	local mode = vim.fn.mode()
	if mode == 'v' or mode == 'V' or mode == '\22' then -- visual, line, block
		local _, ls, cs = unpack(vim.fn.getpos("'<"))
		local _, le, ce = unpack(vim.fn.getpos("'>"))
		-- Normalize order
		if ls > le or (ls == le and cs > ce) then
			ls, le = le, ls
			cs, ce = ce, cs
		end
		local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
		return lines[1] or vim.api.nvim_get_current_line()
	else
		return vim.api.nvim_get_current_line()
	end
end

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
do
	-- Dev folder: Windows default, Linux/macOS default to ~/dev (or override via $NVIM_DEV_DIR).
	local dev = vim.env.NVIM_DEV_DIR
	if not dev or #dev == 0 then
		dev = platform.is_win and "C:\\Development\\Git\\Private" or (platform.home .. "/dev")
	end
	if vim.fn.isdirectory(dev) == 1 then
		vim.keymap.set("n", "<leader>cd", function() open_tree_at(dev) end,
			{ silent = true, desc = "Open NvimTree at Dev folder" })
	end
end

-- Cross-platform project script helpers
-- Windows: .bat files via cmd.exe    Linux: .sh files via bash
-- Output shown live in a terminal tab; captured to a logfile on exit.
local script_ext = platform.is_win and ".bat" or ".sh"
local script_dir = platform.is_win and ".\\scripts\\" or "./scripts/"

local function script_path(name)
	return script_dir .. name .. script_ext
end

local function shell_cmd(name, extra_args)
	local s = script_path(name)
	local cmd
	if platform.is_win then
		cmd = { "cmd.exe", "/c", s }
	else
		cmd = { "bash", s }
	end
	if extra_args then
		for _, a in ipairs(extra_args) do table.insert(cmd, a) end
	end
	return cmd
end

local function run_in_term(cmd, logfile, opts)
	opts = opts or {}
	vim.cmd("tabnew")
	local term_buf = vim.api.nvim_get_current_buf()
	local term_win = vim.api.nvim_get_current_win()

	vim.fn.termopen(cmd, {
		cwd = vim.fn.getcwd(),
		on_exit = function()
			vim.schedule(function()
				if logfile and vim.api.nvim_buf_is_valid(term_buf) then
					local lines = vim.api.nvim_buf_get_lines(term_buf, 0, -1, false)
					while #lines > 0 and lines[#lines] == "" do
						table.remove(lines)
					end
					vim.fn.writefile(lines, logfile)
				end
				if vim.api.nvim_buf_is_valid(term_buf) then
					vim.api.nvim_buf_delete(term_buf, { force = true })
				end
				if vim.api.nvim_win_is_valid(term_win) then
					vim.api.nvim_win_close(term_win, true)
				end
				if logfile then
					vim.cmd("edit " .. logfile)
					if opts.jump_to_end then
						vim.cmd("normal! G")
					end
				end
			end)
		end,
	})
	vim.cmd("startinsert")
end

local LOG = "build_output.log"

vim.keymap.set("n", "<leader>bc", function()
	vim.cmd("wa")
	vim.cmd("! " .. script_path("check"))
end, { desc = "Run check script" })

vim.keymap.set("n", "<leader>bd", function()
	vim.cmd("wa")
	run_in_term(shell_cmd("build", { "Debug" }), LOG, { jump_to_end = true })
end, { desc = "Build Debug" })

vim.keymap.set("n", "<leader>br", function()
	vim.cmd("wa")
	run_in_term(shell_cmd("build", { "Release" }), LOG, { jump_to_end = true })
end, { desc = "Build Release" })

vim.keymap.set("n", "<leader>bt", function()
	vim.cmd("wa")
	run_in_term(shell_cmd("build_with_tests", { "Debug" }), LOG, { jump_to_end = true })
end, { desc = "Build Debug with tests" })

vim.keymap.set("n", "<leader>bed", function()
	vim.cmd("wa")
	run_in_term(shell_cmd("rebuild", { "Debug" }), LOG, { jump_to_end = true })
end, { desc = "Rebuild Debug" })

vim.keymap.set("n", "<leader>ber", function()
	vim.cmd("wa")
	run_in_term(shell_cmd("rebuild", { "Release" }), LOG, { jump_to_end = true })
end, { desc = "Rebuild Release" })

vim.keymap.set("n", "<leader>rr", function()
	run_in_term(shell_cmd("run"), "output.log")
end, { desc = "Run application" })

vim.keymap.set("n", "<leader>rd", function()
	vim.cmd("! " .. script_path("debug"))
end, { desc = "Run debug script" })

vim.keymap.set("n", "<leader>rtt", function()
	local line = current_or_visual_line()
	local filter = gtest_filter_from_line(line)
	local extra = (filter and #filter > 0) and { filter } or nil
	run_in_term(shell_cmd("test", extra), "output_test.log")
end, { desc = "Run tests (current TEST if under cursor)" })

vim.keymap.set("n", "<leader>rtf", function()
	local line = current_or_visual_line()
	local filter = gtest_filter_from_line(line)
	local extra = (filter and #filter > 0) and { filter } or nil
	run_in_term(shell_cmd("test_failed", extra), "output_test.log")
end, { desc = "Run failed tests (current TEST if under cursor)" })

vim.keymap.set("n", "<leader>rtd", function()
	vim.cmd("! " .. script_path("test_debug"))
end, { desc = "Run test debug script" })
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

vim.keymap.set('n', '<C-s>', "<cmd>wa<CR>", { desc = "Save all files" })
vim.keymap.set('i', '<C-s>', "<cmd>wa<CR>", { desc = "Save all files" })

-- Remap Ctrl + hjkl for window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Delete word before cursor in Insert mode
vim.keymap.set("i", "<C-H>", "<C-w>", { noremap = true, desc = 'delete word before cursor' })
vim.keymap.set("c", "<C-h>", "<C-w>", { noremap = true, desc = 'delete word before cursor' })

-- LSP
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true, desc = 'GOTO definition' })
vim.keymap.set("v", "<leader>fl", vim.lsp.buf.format, { remap = false, desc = 'format line' })
vim.keymap.set("n", "<leader>fd", vim.lsp.buf.format, { remap = false, desc = 'format file' })

vim.keymap.set("n", "<leader>ne", vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set("n", "<leader>pe", vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })

-- Bufferline
vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })

-- normalize unicode minus/dash to ASCII hyphen in insert mode
vim.keymap.set('i', '−', '-', { buffer = true }) -- U+2212
vim.keymap.set('i', '–', '-', { buffer = true }) -- U+2013

-- Visual paste: keep your last yank intact
-- Deletes selection to the black-hole register, then pastes what you yanked.
vim.keymap.set("x", "p", [["_dP]], { desc = "Paste without overwriting yank" })

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
