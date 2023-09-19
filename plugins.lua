local plugins = {
	{
  	  "neovim/nvim-lspconfig",
  	  config = function()
  	    require "plugins.configs.lspconfig"
  	    require "custom.configs.lspconfig"
  	  end
  	},
  	{
  	  "nvim-tree/nvim-tree.lua",
  	  opts = function()
  	  	local default_conf = require "plugins.configs.nvimtree"
  	  	local custom_conf = require "custom.configs.nvimtree"
  	  	default_conf.on_attach = custom_conf.on_attach
		default_conf.git = custom_conf.git
  	  	return default_conf
	  end
  	},
  	{
  	  "williamboman/mason.nvim",
  	  opts = {
  	    ensure_installed = {
  	      "clangd",
  	      "codelldb",
		  "lua-language-server",
		  "pyright",
		  "debugpy"
  	    }
  	  }
  	},
  	{
  	  "mfussenegger/nvim-dap",
  	  config = function(_, _)
  	    require("core.utils").load_mappings("dap")
  	  end
  	},
  	{
  	  "jay-babu/mason-nvim-dap.nvim",
  	  event = "VeryLazy",
  	  dependencies = {
  	    "williamboman/mason.nvim",
  	    "mfussenegger/nvim-dap",
  	  },
  	  opts ={
  	    handlers = {}
  	  }
  	},
  	{
  	  "rcarriga/nvim-dap-ui",
  	  event = "VeryLazy",
  	  dependencies = "mfussenegger/nvim-dap",
  	  config = function()
  	    local dap = require("dap")
  	    local dapui = require("dapui")

  	    dapui.setup()
  	    dap.listeners.after.event_initialized["dapui_config"] = function()
  	      dapui.open()
  	    end
  	    dap.listeners.after.event_terminated["dapui_config"] = function()
  	      dapui.close()
  	    end
  	    dap.listeners.after.event_exited["dapui_config"] = function()
  	      dapui.close()
  	    end
  	  end
  	},
  	{
  	  "mfussenegger/nvim-dap-python",
	  ft = "python",
	  dependencies = {
		"mfussenegger/nvim-dap",
		"rcarriga/nvim-dap-ui"
	  },
  	  config = function(_, opts)
		local path = "%LOCALAPPDATA%\\nvim-data\\mason\\packages\\debugpy\\venv\\Scripts\\python.exe"
  	    require("dap-python").setup(path)
		require("core.utils").load_mappings("dap_python")


	-- --require("dap-python").setup(vim.fn.getcwd() .. "\\Scripts\\" .. "python.exe")
	-- require("dap-python").setup("C:\\Development\\Local\\.virtualenvs\\debugpy\\Scripts\\python.exe")
	-- table.insert(require("dap").configurations.python, {
	-- 	type = "python",
	-- 	request = "launch",
	-- 	program = "${file}",
	-- 	console = "integratedTerminal",
	-- 	name = "Launch file with autoReload",
	-- 	justMyCode = false,
	-- 	autoReload = {
	-- 		enable = true,
	-- 	},
	-- })

	-- require("dap-python").resolve_python = function()
	-- 	--return vim.fn.getcwd() .. "\\Scripts\\" .. "python.exe"
	-- 	return "C:\\Development\\Local\\.virtualenvs\\debugpy\\Scripts\\python.exe"
	-- end
  	  end
  	},
	{
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "json",
        "c",
        --"zig",
		--"rust",
		"cpp",
		"c_sharp",
		"python"
      },
    },
  },
}
return plugins
