local plugins = {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"lua",
				"luadoc",
				"vim",
				"vimdoc",
				"cmake",
				"c",
				"cpp"
			},
			indent = { enable = false } --messess up indentation when using namespaces in c++
		}
	},
	{
		"nvim-tree/nvim-tree.lua",
		opts = function()
			local default_conf = require "plugins.configs.nvimtree"
			local custom_conf = require "custom.configs.nvimtree"
			default_conf.on_attach = custom_conf.on_attach
			default_conf.filters.dotfiles = true
			default_conf.view.width = 40
			default_conf.git.enable = true
			default_conf.actions = custom_conf.actions
			return default_conf
		end
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require "plugins.configs.lspconfig"
			require "custom.configs.lspconfig"
		end
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"clangd",
				"codelldb",
				"lua-language-server",
				"cmake-language-server"
			}
		}
	},
	{
		"mfussenegger/nvim-dap",
		config = function(_, _)
			require "core.utils".load_mappings("dap")
		end
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap"
		},
		opts = {
			handlers = {}
		}
	},
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = "mfussenegger/nvim-dap",
		config = function()
			local dap = require "dap"
			local dapui = require "dapui"

			dapui.setup()

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end
	}
}

return plugins
