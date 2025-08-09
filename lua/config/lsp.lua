-- lua/config/lsp.lua
local root = require("config.lsp_root")
local lsp  = vim.lsp

-- Capabilities (blink adds snippetSupport, etc.)
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities       = require("blink.cmp").get_lsp_capabilities(capabilities)

-- Inlay hints: work across Neovim versions (0.11 new API, older fallback)
local function enable_inlay_hints(bufnr, enable)
  enable = enable ~= false
  local ok_new = pcall(function()
    vim.lsp.inlay_hint.enable(enable, { bufnr = bufnr }) -- 0.11+
  end)
  if not ok_new then
    pcall(vim.lsp.inlay_hint.enable, bufnr, enable)      -- older signature
  end
end

local function default_on_attach(client, bufnr)
  if client.server_capabilities.inlayHintProvider then
    enable_inlay_hints(bufnr, true)
  end
end

-- lua
lsp.config("lua_ls", {
  capabilities = capabilities,
  on_attach = default_on_attach,
  settings = {
    Lua = { diagnostics = { globals = { "vim" } } },
  },
})

-- clangd
lsp.config("clangd", {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    default_on_attach(client, bufnr)
    pcall(function()
      require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
    end)
    vim.diagnostic.config({ update_in_insert = true, severity_sort = true })
  end,
})

-- --- Vue & TS setup (Hybrid) --------------------------------------------
-- vue_ls handles templates (HTML / directives / props)
lsp.config("vue_ls", {
  capabilities = capabilities,
  root_dir = root,
  -- Flip this if you want full takeover (vue_ls handles TS too):
  -- settings = { vue = { hybridMode = false } },
  settings = {
    vue = {
      inlayHints = {
        destructuredProps    = { enabled = true },
        inlineHandlerLoading = { enabled = true },
        missingProps         = { enabled = true },
        optionsWrapper       = { enabled = true },
        vBindShorthand       = { enabled = true },
      },
    },
  },
})

-- vtsls handles <script> logic with @vue/typescript-plugin
lsp.config("vtsls", {
  capabilities = capabilities,
  root_dir = root,
  single_file_support = false,
  filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            languages = { "vue" },
            configNamespace = "typescript",
            location = vim.fs.joinpath(
              vim.fn.stdpath("data"), "mason", "packages",
              "vue-language-server", "node_modules", "@vue", "language-server"
            ),
          },
        },
      },
    },

    -- JavaScript parity with TypeScript
    javascript = {
      suggest = { completeFunctionCalls = true },
      preferences = {
        includeCompletionsForModuleExports = true,
        includeCompletionsWithSnippetText = true,
        includeCompletionsWithInsertTextCompletions = true,
      },
      inlayHints = {
        enumMemberValues         = { enabled = true },
        functionLikeReturnTypes  = { enabled = true },
        parameterNames           = { enabled = "all" },
        parameterTypes           = { enabled = true, suppressWhenArgumentMatchesName = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes            = { enabled = true },
      },
    },

    -- TypeScript (match JS)
    typescript = {
      suggest = { completeFunctionCalls = true },
      inlayHints = {
        enumMemberValues         = { enabled = true },
        functionLikeReturnTypes  = { enabled = true },
        parameterNames           = { enabled = "all" },
        parameterTypes           = { enabled = true, suppressWhenArgumentMatchesName = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes            = { enabled = true },
      },
    },
  },
})

-- eslint
lsp.config("eslint", { capabilities = capabilities })

-- pyright / rust_analyzer
lsp.config("pyright",       { capabilities = capabilities })
lsp.config("rust_analyzer", { capabilities = capabilities })

-- Emmet (HTML/CSS/Vue templates)
lsp.config("emmet_language_server", {
  capabilities = capabilities,
  -- Limit to markup-y places so it stays signal > noise
  filetypes = {
    "html", "css", "scss", "sass", "less",
    "vue", "svelte", "astro",
    "javascriptreact", "typescriptreact", -- if you use JSX/TSX
  },
  init_options = {
    -- VS Code-like behavior
    showAbbreviationSuggestions = true,
    showExpandedAbbreviation    = true,
    showSuggestionsAsSnippets   = true,
    -- Nice extra: BEM-style class naming helpers if you like that style
    html                        = { options = { ["bem.enabled"] = true } },
  },
})

-- Signature help popup styling (shared by all LSPs)
lsp.handlers["textDocument/signatureHelp"] = lsp.with(
  lsp.handlers.signature_help,
  {
    border   = "rounded",  -- match your docs window style
    focusable= false,      -- doesn't steal focus
    relative = "cursor",   -- follows your cursor
  }
)

-- Optional: Trigger signature help manually with <C-S> if needed
vim.keymap.set("i", "<C-s>", function()
  vim.lsp.buf.signature_help()
end, { desc = "Show signature help" })

-- Enable the set
lsp.enable({
  "lua_ls",
  "clangd",
  "pyright",
  "rust_analyzer",
  "eslint",
  "vtsls",
  "vue_ls",
  "emmet_language_server",
})
