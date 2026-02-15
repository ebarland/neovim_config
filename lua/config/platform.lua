-- lua/config/platform.lua
-- Small helper module to keep OS-specific logic out of the rest of the config.

local M = {}

M.is_win = (vim.fn.has("win32") == 1) or (vim.fn.has("win64") == 1)
M.is_linux = (vim.fn.has("linux") == 1)
M.is_mac = (vim.fn.has("mac") == 1) or (vim.fn.has("macunix") == 1)

M.sep = package.config:sub(1, 1) -- "\" on Windows, "/" on POSIX
M.home = (vim.uv or vim.loop).os_homedir()

return M


