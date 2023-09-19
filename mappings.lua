local M = {}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {
		"<cmd> DapToggleBreakpoint <CR>",
        "Add breakbpoint at line"
    },
    ["<leader>dr"] = {
		"<cmd> DapContinue <CR>",
		"Start or continue the debugger"
    }
  }
}

M.dap_python = {
	plugin = true,
	n = {
		["<leader>dpr"] = {
			function ()
				require('dap-python').test_method()
			end
		}
	}

}

M.custom = {
	plugin = false,
	n = {
		["<leader>cc"] = {
			":cd C:\\Users\\Egil\\AppData\\Local\\nvim<CR>:NvimTreeToggle<CR>",
			"Move to and open NVIM config directory"
		}
	}
-- Resize with arrows
--keymap("n", "<C-Up>", ":resize -2<CR>", opts)
--keymap("n", "<C-Down>", ":resize +2<CR>", opts)
--keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
--keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)
}

-- In order to disable a default keymap, use
-- M.disabled = {
--   n = {
--       ["<leader>h"] = "",
--       ["<C-a>"] = ""
--   }
-- }

-- Your custom mappings
--M.abc = {
--  n = {
--		
----     ["<C-n>"] = {"<cmd> Telescope <CR>", "Telescope"},
----     ["<C-s>"] = {":Telescope Files <CR>", "Telescope Files"} 
--  }
--
----  i = {
----     ["jk"] = { "<ESC>", "escape insert mode" , opts = { nowait = true }},
----    -- ...
----  }
--}

return M
