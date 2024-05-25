---@type ChadrcConfig
local M = {}

M.ui = {
	theme = "chadracula",
	transparency = true
}

vim.cmd [[hi @property guifg=#ed7d05]]
vim.cmd [[hi @variable.parameter guifg=#040e94]]

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

require "custom.init"

return M

