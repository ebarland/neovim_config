---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "chadracula",
  transparency = true
}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

require "custom.init"

return M
