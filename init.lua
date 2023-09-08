vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local options = {
	backup = false, -- craete backup file
	clipboard = "unnamed", -- access windows clipboard
	cmdheight = 2, -- more space in the cmd line hight in neovim
	completeopt = {"menuone", "noselect"}, -- stuff for cmp (TODO look this up)
	fileencoding = "utf-8", -- saved file format
	hlsearch = true, -- highlight all matches on previous search patterns
	ignorecase = true, -- ignore case in search patterns
	pumheight = 10, -- pop-up menu height
	showmode = false, -- hide the current mode (INSERT, VISUAL, etc)

	mouse = "a", -- sets mouse available in all modes

	--showtabline = 2, -- show tab line at top of buffer
	smartcase = true, -- smart case sensitive searching, is case-insensitive unless you type an UPPER case character

	autoindent = true, -- always set autoindenting on
	--o.copyindent = true, -- copy the previous indentation on autoindenting
	smartindent = true, -- better indenting, can be replaced by cindent and indentexpr too. Is maybe configured by plugins
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go the the right of the current window
	swapfile = false, -- do not create swap files

	termguicolors = true, -- set term GUI colors 

	timeoutlen = 1000, -- time to wait for a mapped sequence to complete
	undofile = true, -- enable persisten undo, saves undo history to file
	updatetime = 300, -- faster completion 4000 defualt
	writebackup = false, -- does not write to a temp file, so will not recover file upon crash
	expandtab = false, -- expands tab to spaces, fuck that
	shiftwidth = 4, -- number of spaces to use for autoindenting
	tabstop = 4,  --  a tab is four spaces

	cursorline = true, -- highlight the current line
	number = true, -- line numbers
	relativenumber = false, -- relative numbers

	numberwidth = 2, -- sets width of number column, default 4
	signcolumn = "number", -- determines how the sign column behaves

	wrap = false, -- line wrapping
	scrolloff = 16, -- sets the number of lines to buffer while scrolling up and down
	sidescrolloff = 16,
	modifiable = true,

	-- o.backspace = "2", -- (default "indent,eol,start") Influences the working of <BS>, <Del>, CTRL-W and CTRL-U in Insert mode.  This is a list of items, separated by commas.  Each item allows a way to backspace over something: 
	--								value	effect 
	--								indent	allow backspacing over autoindent
	--								eol		allow backspacing over line breaks (join lines)
	--								start	allow backspacing over the start of insert; CTRL-W and CTRL-U stop once at the start of insert.
	--								nostop	like start, except CTRL-W and CTRL-U do not stop at the start of insert.
	showcmd = false, -- (default on)	Show (partial) command in the last line of the screen.  Set this option off if your terminal is slow.
	laststatus = 2, -- (default 2) The value of this option influences when the last window will have a status line:
	--								0: never
	--								1: only if there are at least two windows
	--								2: always
	--								3: always and ONLY the last window 
	autowrite = true, -- (default off) Write the contents of the file, if it has been modified, on each :next, :rewind, :last, :first, :previous, :stop,
	--								:suspend, :tag, :!, :make, CTRL-] and CTRL-^ command; and when a :buffer, CTRL-O, CTRL-I, '{A-Z0-9}, or{A-Z0-9} command takes one to another file.
	autoread = true, -- (default on) When a file has been detected to have been changed outside of Vim and it has not been changed inside of Vim, automatically read it again. 

	softtabstop = 4,               -- when hitting <BS>, pretend like a tab is removed, even if spaces
	shiftround = true,             -- use multiple of shiftwidth when indenting with '<' and '>'
	  							-- 
	showmatch = true,              -- set show matching parenthesis
	smarttab = true               -- insert tabs on the start of a line according to shiftwidth, not tabstop
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.api.nvim_command("set fillchars=eob:\\ ")  -- hides the squiggle on empty lines
vim.opt.shortmess:append "c"                           -- don't give |ins-completion-menu| messages
--vim.cmd [[set iskeyword+=-]] -- alternative below as this doesnt seem to work
vim.opt.iskeyword:append "-"                           -- hyphenated words recognized by searches
--vim.opt.formatoptions:remove({ "c", "r", "o" })  --(Don't think this works!) Don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode. 
