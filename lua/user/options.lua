o = vim.opt
o.number = true -- line numbers
o.termguicolors = true

o.backspace = "2"
o.showcmd = true 
o.laststatus = 2 
o.autowrite = true 
o.cursorline = true 
o.autoread = true 

o.ai = true 

o.tabstop = 4                   --  a tab is four spaces
o.softtabstop = 4               -- when hitting <BS>, pretend like a tab is removed, even if spaces
o.shiftwidth = 4                -- number of spaces to use for autoindenting
o.shiftround = true             -- use multiple of shiftwidth when indenting with '<' and '>'
o.autoindent = true             -- always set autoindenting on
o.copyindent = true             -- copy the previous indentation on autoindenting
								-- 
o.showmatch = true              -- set show matching parenthesis
o.smarttab = true               -- insert tabs on the start of a line according to shiftwidth, not tabstop
o.scrolloff = 4                 -- keep 4 lines off the edges of the screen when scrolling
