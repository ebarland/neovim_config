require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
--
local o = vim.o

o.autoindent = true -- always set autoindenting on
o.swapfile = false -- do not create swap files

o.expandtab = false -- expands tab to spaces, fuck that
o.shiftwidth = 4 -- number of spaces to use for autoindenting
o.tabstop = 4 --  a tab is four spaces

o.wrap = false -- line wrapping
o.scrolloff = 16 -- sets the number of lines to buffer while scrolling up and down
o.sidescrolloff = 16
o.modifiable = true

--opt.cino = '>s,e0,n0,f0,{0,}0,^0,L-1,:s,=s,l0,b0,gs,hs,ps,ts,is,+s,c3,C0,/0,(2s,us,U0,w0,W0,m0,j0,J0,)20,*70,#0'
--opt.cindent = true

o.whichwrap = "b,s"

vim.filetype.add { extension = { vs = "glsl" } }
vim.filetype.add { extension = { gs = "glsl" } }
vim.filetype.add { extension = { fs = "glsl" } }

vim.cmd [[hi @module guifg=#bcf0c0]]
vim.cmd [[hi @variable.parameter guifg=#040e94]]
vim.cmd [[hi @variable.member.cpp guifg=#040e94]]
vim.cmd [[hi @lsp.type.macro.cpp guifg=#50fa7b]]
