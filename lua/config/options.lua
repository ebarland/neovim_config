vim.g.mapleader = " " -- leader = space
vim.g.maplocalleader = "\\"
vim.g.loaded_netrw = 1 -- spoof netrw already being loaded to avoid loading it
vim.g.loaded_netrwPlugin = 1 -- spoof netrw already being loaded to avoid loading it

vim.o.termguicolors = true -- optionally enable 24-bit colour
vim.o.clipboard = "unnamedplus" -- allow "p" to paste from system clipboard
vim.o.autoindent = true -- always set autoindenting on
vim.o.swapfile = false -- do not create swap files

vim.o.expandtab = false -- expands tab to spaces, fuck that
vim.o.shiftwidth = 4 -- number of spaces to use for autoindenting
vim.o.tabstop = 4 --  a tab is four spaces

vim.o.wrap = false -- line wrapping
vim.o.scrolloff = 16 -- sets the number of lines to buffer while scrolling up and down
vim.o.sidescrolloff = 16
vim.o.modifiable = true

vim.o.number = true

--opt.cino = '>s,e0,n0,f0,{0,}0,^0,L-1,:s,=s,l0,b0,gs,hs,ps,ts,is,+s,c3,C0,/0,(2s,us,U0,w0,W0,m0,j0,J0,)20,*70,#0'
--opt.cindent = true

vim.o.whichwrap = "b,s"

vim.filetype.add { extension = { vs = "glsl" } }
vim.filetype.add { extension = { gs = "glsl" } }
vim.filetype.add { extension = { fs = "glsl" } }
