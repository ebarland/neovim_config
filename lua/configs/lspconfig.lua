-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "clangd", "glsl_analyzer" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

local on_attach = nvlsp.on_attach
local capabilities = nvlsp.capabilities

lspconfig.glsl_analyzer.setup {
	filetypes = { "glsl", "frag", "vert", "vs", "fs" },
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
	end,
	capabilities = capabilities
}

-- lspconfig.glsl_analyzer.setup {
--   filetypes = { "glsl", "frag", "vert", "vs", "fs" },
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

-- configuring single server, example: typescript
-- lspconfig.ts_ls.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }
