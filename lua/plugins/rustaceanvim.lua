-- lua/plugins/rustaceanvim.lua
return {
	"mrcjkb/rustaceanvim",
	version = "^5",
	lazy = false,
	init = function()
		vim.g.rustaceanvim = function()
			return {
				server = {
					on_attach = function(client, bufnr)
						if client.server_capabilities.inlayHintProvider then
							local ih = vim.lsp.inlay_hint
							if ih and ih.enable then
								pcall(ih.enable, bufnr, vim.g.inlay_hints_enabled and true or false)
							end
						end

						local function map(mode, lhs, rhs, desc)
							vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
						end

						map("n", "<leader>rr", function() vim.cmd.RustLsp("runnables") end, "Rust runnables")
						map("n", "<leader>rd", function() vim.cmd.RustLsp("debuggables") end, "Rust debuggables")
						map("n", "<leader>me", function() vim.cmd.RustLsp("expandMacro") end, "Expand macro")
						map("n", "<leader>rc", function() vim.cmd.RustLsp("openCargo") end, "Open Cargo.toml")
						map("n", "<leader>rp", function() vim.cmd.RustLsp("parentModule") end, "Parent module")
						map("n", "<leader>re", function() vim.cmd.RustLsp("explainError") end, "Explain error")
						map("n", "<leader>rD", function() vim.cmd.RustLsp("renderDiagnostic") end, "Render diagnostic")
						map("n", "J", function() vim.cmd.RustLsp("joinLines") end, "Rust join lines")
						map("n", "<leader>ra", function() vim.cmd.RustLsp("codeAction") end, "Rust code action")
					end,
					capabilities = require("blink.cmp").get_lsp_capabilities(
						vim.lsp.protocol.make_client_capabilities()
					),
					default_settings = {
						["rust-analyzer"] = {
							check = { command = "clippy" },
							procMacro = { enable = true },
							cargo = { allFeatures = true },
							diagnostics = { enable = true },
							completion = {
								postfix = { enable = true },
								callable = { snippets = "fill_arguments" },
							},
							inlayHints = {
								typeHints = { enable = true },
								parameterHints = { enable = true },
								chainingHints = { enable = true },
								closureReturnTypeHints = { enable = "always" },
								lifetimeElisionHints = { enable = "skip_trivial" },
							},
						},
					},
				},
			}
		end
	end,
}
