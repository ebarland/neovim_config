return
{
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- event = "BufReadPost",  -- Lazy load after a file is read into a buffer
    config = function ()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
          ensure_installed = { "lua", "vim", "vimdoc", "cpp"  },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
        })
    end
 }
