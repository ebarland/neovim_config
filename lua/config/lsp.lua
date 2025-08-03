-- Neovim 0.11+ native LSP config
-- :help lsp, :LspInfo to verify
-- Tip: you can split these into separate files under lua/lsp/ if you prefer.

-- ------------- common helpers -------------
local lsp = vim.lsp

-- Mason install location for the Vue TS plugin (used by vtsls)
local mason_pkgs = vim.fn.stdpath("data") .. "/mason/packages"
local vue_ts_plugin = mason_pkgs .. "/vue-language-server/node_modules/@vue/language-server"

-- ------------- your existing servers -------------
lsp.config("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})

lsp.config("clangd", {
  on_attach = function(client, bufnr)
    -- keep your existing logic
    pcall(function()
      require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
    end)
    vim.diagnostic.config({ update_in_insert = true, severity_sort = true })
  end,
})

-- ------------- vtsls (must attach to .vue) -------------
lsp.config("vtsls", {
  -- Ensure it runs for Vue buffers:
  filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
  settings = {
    vtsls = {
      tsserver = {
        -- Load the Vue TypeScript plugin so TS features work inside <script> of .vue
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_ts_plugin,
            languages = { "vue" },
          },
        },
      },
    },
  },
})

-- ------------- vue_ls -------------
-- Keep vue_ls minimal; it will forward TS requests to vtsls.
lsp.config("vue_ls", {
  -- You can add Vue-specific opts here if you need them later.
})

-- ------------- other servers you listed -------------
lsp.config("pyright", {})
lsp.config("rust_analyzer", {})
lsp.config("eslint", {})

-- Finally, *explicitly* enable the servers you want auto-started:
lsp.enable({
  "lua_ls",
  "clangd",
  "pyright",
  "rust_analyzer",
  "eslint",
  "vtsls",   -- must be enabled for .vue TS
  "vue_ls",
})
