-- lua/plugins/completion.lua
return {
	"saghen/blink.cmp",
	version = "1.*",
	opts = {
		keymap = { preset = "super-tab" },
		appearance = { nerd_font_variant = "mono" },
		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 150, -- small delay to avoid flicker
				update_delay_ms = 50,
				window = {
					border = "rounded", -- nicer frame (optional)
					max_width = 80,
					max_height = 30,
					scrollbar = true,
				},
			},
			trigger = {
				show_on_keyword = true,
				-- show_on_backspace = true,
				show_on_backspace_in_keyword = true,
				show_on_backspace_after_insert_enter = true,
				show_on_backspace_after_accept = true,
			},
			ghost_text = { enabled = true }, -- inline preview of the currently selected item
		},
		sources = {
			default = { "lsp", "snippets", "path", "buffer" },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
