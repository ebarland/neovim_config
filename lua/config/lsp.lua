-- lua/config/lsp.lua
local lsp          = vim.lsp

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities       = require("blink.cmp").get_lsp_capabilities(capabilities)

local function default_on_attach(client, bufnr)
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

-- lua
lsp.config("lua_ls", {
	capabilities = capabilities,
	on_attach = default_on_attach,
	settings = {
		Lua = { diagnostics = { globals = { "vim" } } }, -- fix lua LSP warning about vim keyword/namespace
	},
})

lsp.config("clangd", {
	capabilities = capabilities,
	on_attach = default_on_attach,
	cmd = {
		"clangd",
		"--background-index",
		"--header-insertion=never",
		"--query-driver=C:/Program Files/Microsoft Visual Studio/*/VC/Tools/MSVC/*/bin/**/cl.exe," ..
			"C:/msys64/mingw64/bin/g++.exe," ..
			"C:/msys64/ucrt64/bin/g++.exe," ..
			"C:/Program Files/LLVM/bin/clang++.exe",
		"--pch-storage=memory",
		"--clang-tidy",
		"--log=error",
	},
})
lsp.config("pyright", { capabilities = capabilities, on_attach = default_on_attach, })
lsp.config("rust_analyzer", { capabilities = capabilities, on_attach = default_on_attach, })

local root = require("config.lsp_root")

lsp.config("vue_ls", {
	capabilities = capabilities,
	on_attach = default_on_attach,
	root_dir = root, -- keep from spawning multiple LSPs when opening node_modules files
})

lsp.config("vtsls", {
	capabilities = capabilities,
	root_dir = root, -- keep from spawning multiple LSPs when opening node_modules files
	single_file_support = false,
	on_attach = default_on_attach,
	filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" },
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						languages = { "vue" },
						configNamespace = "typescript",
						location = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "vue-language-server",
							"node_modules", "@vue", "language-server"
						),
					},
				}
			}
		}
	}
})

lsp.handlers["textDocument/signatureHelp"] = lsp.with(
	lsp.handlers.signature_help,
	{
		border    = "rounded",
		focusable = false,
		relative  = "cursor",
	}
)

lsp.enable({
	"lua_ls",
	"clangd",
	"pyright",
	"rust_analyzer",
	"vtsls",
	"vue_ls",
})
