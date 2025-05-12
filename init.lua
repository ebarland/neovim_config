
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

require("config.lazy")

vim.lsp.enable({'clangd'})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.diagnostic.config({
  -- Use the default configuration
  virtual_lines = true

  -- Alternatively, customize specific options
  -- virtual_lines = {
  --  -- Only show virtual line diagnostics for the current cursor line
  --  current_line = true,
  -- },
})

vim.keymap.set('n', '<leader>e', "<cmd>NvimTreeToggle<CR>", {desc="Toggle NvimTree"})
-- vim.keymap.set("n", "<leader>cc", ":cd " .. config_dir .. "<CR>:NvimTreeFocus<CR>", { desc = "Move to and open NVIM config directory" })

-- Helper function to open (or re-open) NvimTree at a specific directory
local function open_tree_at(dir)
  -- escape the path (in case it has spaces, backslashes, etc.)
  local escaped = vim.fn.fnameescape(dir)

  -- 1. Change Neovim’s cwd
  vim.cmd("cd " .. escaped)

  -- 2. Close any existing NvimTree window so we can reopen it fresh
  require("nvim-tree.api").tree.close()

  -- 3. Open NvimTree at the new cwd and update its root
  require("nvim-tree.api").tree.open({ path = dir, update_root = true })
end

-- <leader>cc → cd into your Neovim config folder and open NvimTree there
vim.keymap.set("n", "<leader>cc", function()
  open_tree_at(vim.fn.stdpath("config"))
end, { silent = true, desc = "Open NvimTree at Neovim config" })

-- <leader>cd → cd into your development folder and open NvimTree there
vim.keymap.set("n", "<leader>cd", function()
  open_tree_at("C:\\Development\\Git\\Private")
end, { silent = true, desc = "Open NvimTree at Dev folder" })