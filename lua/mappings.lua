require "nvchad.mappings"

-- Disable mappings
local nomap = vim.keymap.del
nomap("n", "<leader>b")
nomap("n", "<leader>e")
-- nomap("n", "<C-n>")
-- nomap("n", "<C-.>")
-- nomap("n", "<C-m>")
-- nomap("n", "<C-o>")
-- nomap("n", )

local map = vim.keymap.set
local config_dir = vim.fn.stdpath "config"

map(
  "n",
  "<leader>cc",
  ":cd " .. config_dir .. "<CR>:NvimTreeFocus<CR>",
  { desc = "Move to and open NVIM config directory" }
)
map(
  "n",
  "<leader>cd",
  ":cd C:\\Development\\Git\\Private<CR>:NvimTreeFocus<CR>",
  { desc = "Move to and open GIT directory" }
)
map(
  "n",
  "<leader>ctg",
  ":! xcopy /s /y " .. config_dir .. "\\lua\\custom C:\\Development\\Git\\Private\\neovim_config<CR>",
  { desc = "Copies and overwrites the local neovim config to neovim_git folder" }
)
map("n", "<leader>bd", ":wa<CR>:! .\\scripts\\build.bat Debug<CR>", { desc = "runs build.bat with Debug config" })
map("n", "<leader>be", ":wa<CR>:! .\\scripts\\rebuild.bat Debug<CR>", { desc = "runs rebuild.bat with Debug config" })
map("n", "<leader>br", ":wa<CR>:! .\\scripts\\build.bat Release<CR>", { desc = "runs build.bat with Release config" })
map("n", "<leader>rr", ":! .\\scripts\\run.bat<CR>", { desc = "runs run.bat" })
map("n", "<leader>rd", ":! .\\scripts\\debug.bat<CR>", { desc = "runs debug.bat" })
map("n", "<leader>rt", ":! .\\scripts\\test.bat<CR>", { desc = "runs test.bat" })
map("n", "<leader>rft", ":! .\\scripts\\test_failed.bat<CR>", { desc = "runs test_failed.bat" })
map("n", "<leader>gl", "<cmd> :lua require('glslView').glslView({'-w', '128', '-h', '256'}) <CR>", { desc = "Toggle GLSL Viewer" })

map("n", "<leader>e", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle nvimtree" })
map("n", "<leader>gd", "<cmd>Trouble diagnostics<CR>", { desc = "Toggle Trouble" })

-- map("n", "", "", {desc = ""})
-- map("n", "", "", {desc = ""})
-- map("n", "", "", {desc = ""})

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
