-- lua/config/options.lua
vim.g.mapleader          = ' '
vim.g.mapleader          = " "           -- leader = space
vim.g.maplocalleader     = "\\"
vim.g.loaded_netrw       = 1             -- spoof netrw already being loaded to avoid loading it
vim.g.loaded_netrwPlugin = 1             -- spoof netrw already being loaded to avoid loading it

vim.o.termguicolors      = true          -- optionally enable 24-bit colour
vim.o.clipboard          = "unnamedplus" -- allow "p" to paste from system clipboard
vim.o.autoindent         = true          -- always set autoindenting on
vim.o.smartindent        = true          -- always set autoindenting on
vim.o.swapfile           = false         -- do not create swap files
vim.o.cindent            = true

vim.o.expandtab          = false -- expands tab to spaces, fuck that
vim.o.shiftwidth         = 4     -- number of spaces to use for autoindenting
vim.o.tabstop            = 4     --  a tab is four spaces

-- Engine and startup behavior:
-- Since we only define folds for function bodies, “start closed”
-- means: functions closed, everything else open.
vim.o.foldenable         = true
vim.o.foldmethod         = "expr"
vim.o.foldexpr           = "nvim_treesitter#foldexpr()"
vim.o.foldlevel          = 0
vim.o.foldlevelstart     = 0
vim.o.foldcolumn         = "1"


vim.o.wrap = false   -- line wrapping
vim.o.scrolloff = 16 -- sets the number of lines to buffer while scrolling up and down
vim.o.sidescrolloff = 16
vim.o.modifiable = true
vim.o.undofile = true
vim.o.number = true

vim.o.textwidth = 360

vim.o.winborder = "rounded"

vim.o.whichwrap = "b,s"

vim.opt.shortmess:append("I")

vim.filetype.add { extension = { vs = "glsl" } }
vim.filetype.add { extension = { gs = "glsl" } }
vim.filetype.add { extension = { fs = "glsl" } }
