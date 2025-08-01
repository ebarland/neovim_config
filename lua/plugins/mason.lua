return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
    ensure_installed = {
      "vue_ls", "vtsls", "eslint",
      "clangd", "lua_ls", "pyright", "rust_analyzer",
    },
    -- optional: turn off auto-enabling if you prefer your own vim.lsp.enable()
    -- automatic_enable = false,
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} }, -- still need Mason itself
    "neovim/nvim-lspconfig",
  },
}
