return {
	'akinsho/bufferline.nvim',
	version = "*",
	dependencies = 'nvim-tree/nvim-web-devicons',
	config = function()
		require("bufferline").setup {
			options = {
				always_show_bufferline = false, -- 👈 add this
				highlights = {
					-- this is the group that styles the *selected* buffer tab
					buffer_selected    = {
						gui = "NONE", -- turn off bold and italic
						guifg = nil, -- leave your chosen fg color intact
						guibg = nil, -- leave your chosen bg color intact
					},
					-- you might also want to catch the little indicator bar below the tab:
					indicator_selected = {
						gui = "NONE",
					},
					-- if you’re using “pick” mode, these too:
					pick_selected      = { gui = "NONE" },
					pick_visible       = { gui = "NONE" },
					pick               = { gui = "NONE" },
				},
				offsets = {
					{
						filetype = "NvimTree",
						text = "Nvim Tree",
						-- separator = true,
						padding = 0.1,
						text_align = "left",
						highlight = "NvimTreeNormal",
					}
				},
				indicator_icon = "",
				diagnostics = "nvim_lsp",
				enforce_regular_tabs = true,
				separator_style = "thin",
				modified_icon = '●',
				show_close_icon = false,
				show_buffer_close_icons = false,
			}
		}
	end
}
