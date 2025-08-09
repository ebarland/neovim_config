-- init.lua
require("config.lazy")
require("config.keymaps")
require("config.lsp")

-- Diagnostics: keep your virtual_lines for current line
vim.diagnostic.config({
  virtual_lines = { current_line = true },
})

-- Auto-insert mode in terminal buffers (your original)
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.cmd("startinsert")
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.o.scrolloff = 0
  end,
})
