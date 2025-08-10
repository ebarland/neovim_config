-- lua/plugins/signature.lua
return {
	"ray-x/lsp_signature.nvim",
	event = "LspAttach",
	opts = {
		bind = true,
		floating_window = true,
		floating_window_above_cur_line = true,
		hint_enable = true,       -- disable inline hints; just use the popup
		handler_opts = { border = "rounded" },
		toggle_key = "<C-s>",     -- press in insert mode to toggle
		select_signature_key = "<C-n>", -- cycle overloads
		move_cursor_key = "<C-m>", -- jump to param (optional)
		-- Automatically trigger on ( and , — works even when servers are picky
		always_trigger = true,
		zindex = 60,
	},
}
