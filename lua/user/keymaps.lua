local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("n", "<leader>h", ":nohlsearch<CR>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", ":m .+1<CR>==", opts)
keymap("n", "<A-k>", ":m .-2<CR>==", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<A-h>", "<gv^", opts)
keymap("v", "<A-l>", ">gv^", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
--keymap("x", "J", ":m '>+1<CR>gv=gv", opts)
--keymap("x", "K", ":m '<-2<CR>gv=gv", opts)
keymap("x", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("x", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

local status, _ = pcall(require, "telescope")
if not status then
	print("Telescope not found:", plugin)
else
	local builtin = require("telescope.builtin")
	keymap("n", "<leader>ff", builtin.find_files, {})
	keymap("n", "<leader>fg", builtin.live_grep, {})
	keymap("n", "<leader>fb", builtin.buffers, {})
	keymap("n", "<leader>fh", builtin.help_tags, {})
end

 local tree_status, _ = pcall(require, "nvim-tree")
 if not tree_status then
 	print("nvim-tree not found:", plugin)
 else
 	keymap("n", "<leader>t", ":NvimTreeToggle<CR>", {})
	keymap("n", "<leader>b", ":! build.bat<CR>", {})
	keymap("n", "<leader>d", ":! debug.bat<CR>", {})
	keymap("n", "<leader>r", ":! run.bat<CR>", {})

 	local api = require('nvim-tree.api')

	local function opts(desc)
		return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	keymap("n", "<C-o>", api.tree.change_root_to_node, opts("CD"))
	keymap("n", "<C-u>", api.tree.change_root_to_parent, opts("Up"))
end
