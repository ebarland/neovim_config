-- n, v, i, t = mode names

local M = {}

M.disabled = {
  n = {
    ["<leader>b"] = "",
    ["<leader>e"] = "",
    ["<C-n>"] = "",
    ["<C-.>"] = ""
  }
}

M.custom = {
  plugin = false,
  n = {
    ["<leader>cc"] = {
      ":cd C:\\Users\\Egil\\AppData\\Local\\nvim<CR>:NvimTreeFocus<CR>",
      "Move to and open NVIM config directory"
    },
    ["<leader>cd"] = {
      ":cd C:\\Development\\Git<CR>:NvimTreeFocus<CR>",
      "Move to and open GIT directory"
    },
    ["<leader>bb"] = {
      ":! .\\scripts\\build.bat<CR>",
      "runs build.bat"
    },
    ["<leader>br"] = {
      ":! .\\scripts\\run.bat<CR>",
      "runs run.bat"
    },
    ["<leader>bd"] = {
      ":! .\\scripts\\debug.bat<CR>",
      "runs debug.bat"
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
