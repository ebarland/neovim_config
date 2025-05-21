return
{
	'akinsho/bufferline.nvim',
	version = "*",
	dependencies = 'nvim-tree/nvim-web-devicons',
	config = function()
		require("bufferline").setup {
			options = {
				offsets = {
					{
						filetype = "NvimTree",
						text = "Nvim Tree",
						-- separator = true,
						padding = 1,
						text_align = "left"
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
