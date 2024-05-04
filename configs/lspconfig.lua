local base = require "plugins.configs.lspconfig"
local on_attach = base.on_attach
local capabilities = base.capabilities

local lspconfig = require "lspconfig"

lspconfig.clangd.setup {
	on_attach = function(client, bufnr)
		client.server_capabilities.signatureHelpProvider = false
		on_attach(client, bufnr)
	end,
	capabilities = capabilities
}

lspconfig.cmake.setup {

}

-- lspconfig.glsl_analyzer.setup {
--
-- }

-- "languageserver": {
--   "cmake": {
--     "command": "cmake-language-server",
--     "filetypes": ["cmake"],
--     "rootPatterns": [
--       "build/"
--     ],
--     "initializationOptions": {
--       "buildDirectory": "build"
--     }
--   }
-- }
