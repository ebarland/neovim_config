-- lua/config/lsp.lua
local lsp          = vim.lsp
local platform     = require("config.platform")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities       = require("blink.cmp").get_lsp_capabilities(capabilities)

-- Inlay hints helpers that work on Neovim 0.10+ and 0.11+
local function ih_is_enabled(buf)
	local ih = vim.lsp.inlay_hint
	if not ih or not ih.is_enabled then return false end
	-- Try new API first: is_enabled(bufnr)
	local ok, res = pcall(ih.is_enabled, buf)
	if ok then return res end
	-- Fallback old API: is_enabled({ bufnr = ... })
	ok, res = pcall(ih.is_enabled, { bufnr = buf })
	return ok and res or false
end

local function ih_enable(buf, state)
	local ih = vim.lsp.inlay_hint
	if not ih or not ih.enable then return end
	-- Try new API first: enable(bufnr, state)
	if not pcall(ih.enable, buf, state) then
		-- Fallback old API: enable(state, { bufnr = ... })
		pcall(ih.enable, state, { bufnr = buf })
	end
end

local function ih_toggle(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	ih_enable(buf, not ih_is_enabled(buf))
end

-- Global desired default (true = on, false = off). Default to true if unset.
vim.g.inlay_hints_enabled = true

local function ih_apply_to_buf_if_supported(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	for _, c in ipairs(clients) do
		if c.server_capabilities.inlayHintProvider then
			ih_enable(bufnr, vim.g.inlay_hints_enabled and true or false)
			return
		end
	end
end

local function ih_apply_to_all_buffers()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(bufnr) then
			ih_apply_to_buf_if_supported(bufnr)
		end
	end
end

local function ih_toggle_global()
	vim.g.inlay_hints_enabled = not (vim.g.inlay_hints_enabled and true or false)
	ih_apply_to_all_buffers()
end


local function default_on_attach(client, bufnr)
	if client.server_capabilities.inlayHintProvider then
		ih_apply_to_buf_if_supported(bufnr) -- applies vim.g.inlay_hints_enabled
	end
end


-- Global toggle (updates default + syncs all current LSP buffers)
vim.keymap.set("n", "<leader>iH", function() ih_toggle_global() end,
	{ desc = "Toggle inlay hints (global + all buffers)" })

vim.api.nvim_create_user_command("InlayHintsToggleGlobal", function()
	ih_toggle_global()
end, {})



-- Keybind: <leader>ih toggles inlay hints in the current buffer
vim.keymap.set("n", "<leader>ih", function() ih_toggle() end,
	{ desc = "Toggle inlay hints (current buffer)" })

-- Also expose a command: :InlayHintsToggle
vim.api.nvim_create_user_command("InlayHintsToggle", function()
	ih_toggle()
end, {})





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
	root_markers = { "compile_commands.json", "compile_flags.txt" },
	filetypes = { "c", "cpp", "h", "hpp" },
	init_options = { fallbackFlags = { "-std=c++2a" } },
	single_file_support = true,
	flags = {
		debounce_text_changes = 100,
	},
	cmd = (function()
		local cmd = {
			"clangd",
			"--background-index",
			"--header-insertion=never",
			"--pch-storage=memory",
			"--clang-tidy",
			"--log=error",
			"--all-scopes-completion",
			"--pretty",
			"--header-insertion-decorators",
			"--function-arg-placeholders=true",
			"--completion-style=detailed",
		}
		-- Windows-only: help clangd find MSVC / mingw drivers.
		if platform.is_win then
			table.insert(cmd, "--query-driver=C:/Program Files/Microsoft Visual Studio/*/VC/Tools/MSVC/*/bin/**/cl.exe," ..
				"C:/msys64/mingw64/bin/g++.exe," ..
				"C:/msys64/ucrt64/bin/g++.exe," ..
				"C:/Program Files/LLVM/bin/clang++.exe")
		end
		return cmd
	end)(),
})
lsp.config("pyright", { capabilities = capabilities, on_attach = default_on_attach, })
lsp.config("cmake",
	{ capabilities = capabilities, on_attach = default_on_attach, filetypes = { "cmake" } })

local root = require("config.lsp_root")

lsp.config("vue_ls", {
	capabilities = capabilities,
	on_attach = default_on_attach,
	root_dir = root, -- keep from spawning multiple LSPs when opening node_modules files
})

lsp.config("vtsls", {
	capabilities = capabilities,
	root_dir = root,
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
						location = vim.fs.joinpath(
							vim.fn.stdpath("data"),
							"mason", "packages", "vue-language-server",
							"node_modules", "@vue", "language-server"
						),
					},
				},
			},
		},
	},
})

lsp.config("eslint", {
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		default_on_attach(client, bufnr)
		-- Optional: auto-fix on save once, in addition to Conform
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.code_action({
					context = { only = { "source.fixAll.eslint" } },
					apply = true,
				})
			end,
		})
	end,
	settings = { -- works with flat or legacy config
		workingDirectory = { mode = "auto" },
	},
})

lsp.config("tailwindcss", {
	capabilities = capabilities,
	on_attach = default_on_attach,
	root_dir = root,
	filetypes = { "vue", "typescriptreact", "javascriptreact", "typescript", "javascript", "html", "css" },
})

lsp.handlers["textDocument/signatureHelp"] = lsp.with(
	lsp.handlers.signature_help,
	{
		border    = "rounded",
		focusable = false,
		relative  = "cursor",
	}
)

-- On Linux servers (often minimal), avoid enabling Node-based web LSPs by default.
-- You can still install/enable them later by editing this list.
local enable = { "lua_ls", "pyright" }
if platform.is_win then
	vim.list_extend(enable, { "cmake", "clangd", "vtsls", "vue_ls", "eslint", "tailwindcss" })
else
	-- If you ever need them on Linux, add them here.
	vim.list_extend(enable, { "cmake", "clangd" })
end

lsp.enable(enable)
