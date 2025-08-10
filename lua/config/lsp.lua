-- lua/config/lsp.lua
local root         = require("config.lsp_root")
local lsp          = vim.lsp

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
		pcall(vim.lsp.inlay_hint.enable, bufnr, enable) -- older signature
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

lsp.config("clangd", { capabilities = capabilities, on_attach = default_on_attach, })
lsp.config("pyright", { capabilities = capabilities, on_attach = default_on_attach, })
lsp.config("rust_analyzer", { capabilities = capabilities, on_attach = default_on_attach, })

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

-- Signature help popup styling (shared by all LSPs)
lsp.handlers["textDocument/signatureHelp"] = lsp.with(
	lsp.handlers.signature_help,
	{
		border    = "rounded", -- match your docs window style
		focusable = false, -- doesn't steal focus
		relative  = "cursor", -- follows your cursor
	}
)

-- Optional: Trigger signature help manually with <C-S> if needed
vim.keymap.set("i", "<C-s>", function()
	vim.lsp.buf.signature_help()
end, { desc = "Show signature help" })

lsp.enable({
	"lua_ls",
	"clangd",
	"pyright",
	"rust_analyzer",
	"vtsls",
	"vue_ls",
})
