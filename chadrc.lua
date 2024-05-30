---@type ChadrcConfig
local M = {}

M.ui = {
	theme = "chadracula",
	transparency = true
}

-- vim.cmd [[hi @property guifg=#ffffff]]
-- vim.cmd [[hi @variable guifg=#6f0cfa]]
vim.cmd [[hi @module guifg=#bcf0c0]]
vim.cmd [[hi @variable.parameter guifg=#040e94]]
-- vim.cmd [[hi @variable.member.cpp guifg=#040e94]]
vim.cmd [[hi @lsp.type.macro.cpp guifg=#50fa7b]]

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

require "custom.init"

return M
