local opt = vim.opt
-- local g = vim.g
--
-- -------------------------------------- options ------------------------------------------
-- opt.laststatus = 3 -- global statusline
-- opt.showmode = false
--
-- opt.clipboard = "unnamedplus"
-- opt.cursorline = true
--
-- -- Indenting
-- opt.expandtab = true
-- opt.shiftwidth = 2
-- opt.smartindent = true
-- opt.tabstop = 2
-- opt.softtabstop = 2
--
-- opt.fillchars = { eob = " " }
-- opt.ignorecase = true
-- opt.smartcase = true
-- opt.mouse = "a"
--
-- -- Numbers
-- opt.number = true
-- opt.numberwidth = 2
-- opt.ruler = false
--
-- -- disable nvim intro
-- opt.shortmess:append "sI"
--
-- opt.signcolumn = "yes"
-- opt.splitbelow = true
-- opt.splitright = true
-- opt.termguicolors = true
-- opt.timeoutlen = 400
-- opt.undofile = true
--
-- -- interval for writing swap file to disk, also used by gitsigns
-- opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line

opt.autoindent = true -- always set autoindenting on
--opt.copyindent = true -- copy the previous indentation on autoindenting
opt.swapfile = false  -- do not create swap files

opt.expandtab = false -- expands tab to spaces, fuck that
opt.shiftwidth = 4    -- number of spaces to use for autoindenting
opt.tabstop = 4       --  a tab is four spaces

opt.wrap = false      -- line wrapping
opt.scrolloff = 16    -- sets the number of lines to buffer while scrolling up and down
opt.sidescrolloff = 16
opt.modifiable = true

--opt.cino = '>s,e0,n0,f0,{0,}0,^0,L-1,:s,=s,l0,b0,gs,hs,ps,ts,is,+s,c3,C0,/0,(2s,us,U0,w0,W0,m0,j0,J0,)20,*70,#0'
--opt.cindent = true

opt.whichwrap = "b,s"

--opt.foldtype = 'expr'
--opt.foldexpr = 'nvim_treesitter#foldexpr()'

opt.foldcolumn = '1'
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true