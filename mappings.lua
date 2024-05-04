-- n, v, i, t = mode names

local M = {}

M.disabled = {
	n = {
		["<leader>b"] = "",
		["<leader>e"] = "",
		["<C-n>"] = "",
		["<C-.>"] = "",
		["<C-m>"] = "",
		["<C-o>"] = ""
	}
}

--| Variable       | Default Value                                                                |
--|----------------|------------------------------------------------------------------------------|
--| %SystemDrive%  | C:                                                                           |
--| %ProgramFiles% | C:\Program Files                                                             |
--| %AppData%      | C:\Users\{username}\AppData\Roaming                                          |
--| %LocalAppData% | C:\Users\{username}\AppData\Local                                            |
--| %UserProfile%  | C:\Users\{username}                                                          |
--| %UserName%     | {username}                                                                   |
--| %COMPUTERNAME% | {computername}                                                               |
--| %PATH%         | C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;{plus program paths} |

local config_dir = vim.fn.stdpath("config")

M.custom = {
	plugin = false,
	n = {
		["<leader>cc"] = {
			":cd " .. config_dir .. "<CR>:NvimTreeFocus<CR>",
			"Move to and open NVIM config directory"
		},
		["<leader>cd"] = {
			":cd C:\\Development\\Git\\Private<CR>:NvimTreeFocus<CR>",
			"Move to and open GIT directory"
		},
		["<leader>ctg"] = {
			":! xcopy /s /y " .. config_dir .. "\\lua\\custom C:\\Development\\Git\\Private\\neovim_config<CR>",
			"Copies and overwrites the local neovim config to neovim_git folder"
		},
		["<leader>bbd"] = {
			":! .\\scripts\\build_debug.bat<CR>",
			"runs build_debug.bat"
		},
		["<leader>bbr"] = {
			":! .\\scripts\\build_release.bat<CR>",
			"runs build_release.bat"
		},
		["<leader>br"] = {
			":! .\\scripts\\run.bat<CR>",
			"runs run.bat"
		},
		["<leader>bdd"] = {
			":! .\\scripts\\debug.bat<CR>",
			"runs debug.bat"
		},
		["<leader>tt"] = {
			"<cmd> ZenMode <CR>",
			"Toggle Zen Mode"
		},
		["<C-me"] = {
			"zA",
			"fold open"
		}
	}
}

M.dap = {
	plugin = true,
	n = {
		["<F5>"] = {
			"<cmd> DapContinue <CR>",
			"Start/continue debugger"
		},
		["<S-F5>"] = {
			"<cmd> DapTerminate <CR>",
			"Start/continue debugger"
		},
		["<F9>"] = {
			"<cmd> DapToggleBreakpoint <CR>",
			"Add/remove breakpoint"
		},
		["<F10>"] = {
			"<cmd> DapStepOver <CR>",
			"Step over"
		},
		["<F11>"] = {
			"<cmd> DapStepInto <CR>",
			"Step into"
		},
		["<F4>"] = {
			"<Cmd>lua require\"dapui\".toggle()<CR>",
			"Toggle DAP-UI"
		}
	}
}

M.nvimtree = {
	plugin = true,
	n = {
		["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" }
	}
}

return M
