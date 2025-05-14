vim.keymap.set('n', '<leader>e', "<cmd>NvimTreeToggle<CR>", {desc="Toggle NvimTree"})

local function open_tree_at(dir)
  local escaped = vim.fn.fnameescape(dir)
  vim.cmd("cd " .. escaped)
  require("nvim-tree.api").tree.close()
  require("nvim-tree.api").tree.open({ path = dir, update_root = true })
end

vim.keymap.set("n", "<leader>cc", function()  open_tree_at(vim.fn.stdpath("config")) end, { silent = true, desc = "Open NvimTree at Neovim config" })
vim.keymap.set("n", "<leader>cd", function()  open_tree_at("C:\\Development\\Git\\Private") end, { silent = true, desc = "Open NvimTree at Dev folder" })

-- Remap Ctrl + hjkl for window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Delete word before cursor in Insert mode
vim.keymap.set("i", "<C-H>", "<C-w>", { noremap = true })
vim.keymap.set("c", "<C-h>", "<C-w>", { noremap = true })

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
