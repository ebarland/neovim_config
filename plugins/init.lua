return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "cpp",
        "glsl",
      },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = function(_, conf)
      local custom_conf = require "configs.nvimtree"
      conf.on_attach = custom_conf.on_attach
      conf.filters.dotfiles = true
      conf.view.width = 40
      conf.actions = custom_conf.actions
      return conf
    end,
  },
}
