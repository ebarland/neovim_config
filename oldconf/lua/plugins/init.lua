return {
  {
    "vague2k/vague.nvim",
    config = function()
      require("vague").setup {
        -- optional configuration here
      }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    enabled = false,
  },
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
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    lazy = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "luadoc",
        "vim",
        "vimdoc",
        "cmake",
        "html",
        "css",
        "c",
        "cpp",
        "glsl",
        "c_sharp",
      },
      indent = { enable = false }, --messes up indentation when using namespaces in c++
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = function(_, conf)
      local custom_conf = require "configs.nvimtree"
      conf.on_attach = custom_conf.on_attach
      conf.git = custom_conf.git
      conf.filters.dotfiles = custom_conf.filters.dotfiles
      conf.view.width = custom_conf.width
      conf.actions = custom_conf.actions
      return conf
    end,
    lazy = false,
  },
  {
    "timtro/glslView-nvim",
    ft = "glsl",
  },
}
