local plugins = {
	-- Lua
	{
		"lukas-reineke/indent-blankline.nvim",
		enabled = false
	},
	{
		"lewis6991/gitsigns.nvim",
		enabled = false
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		lazy = false
	},
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
				"cpp",
				"glsl"
			},
			indent = { enable = false } --messes up indentation when using namespaces in c++
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
			default_conf.git.timeout = 100000
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
				"cmake-language-server",
				"glsl_analyzer"
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
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio" },
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
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
				-- height and width can be:
				-- * an absolute number of cells when > 1
				-- * a percentage of the width / height of the editor when <= 1
				-- * a function that returns the width or the height
				width = 250, -- width of the Zen window
				height = 1, -- height of the Zen window
				-- by default, no options are changed for the Zen window
				-- uncomment any of the options below, or add other vim.wo options you want to apply
				options = {
					signcolumn = "no", -- disable signcolumn
					number = false, -- disable number column
					relativenumber = false, -- disable relative numbers
					cursorline = false, -- disable cursorline
					cursorcolumn = false, -- disable cursor column
					foldcolumn = "0", -- disable fold column
					list = false, -- disable whitespace characters
				},
			},
		}
		,
		lazy = false
	},
	{
		"timtro/glslView-nvim", ft = 'glsl'
	}
}

return plugins
