return {
	"nvzone/floaterm",
	dependencies = "nvzone/volt",
	cmd = "FloatermToggle",
	keys = {
		{ "<C-\\>", "<cmd>FloatermToggle<cr>", mode = { "n", "t" }, desc = "Toggle terminal" },
	},
	opts = {
		size = { h = 70, w = 80 },
		terminals = {
			{ name = "Terminal" },
			{ name = "Build" },
		},
		mappings = {
			sidebar = function(buf)
				vim.keymap.set("n", "q", "<cmd>FloatermToggle<cr>", { buffer = buf })
				vim.keymap.set("n", "d", function()
					local state = require("floaterm.state")
					local utils = require("floaterm.utils")
					local api = require("floaterm.api")

					local active_buf = state.buf
					local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
					local target = state.terminals[cursor_line]

					api.delete_term()

					-- If we deleted a non-active terminal, switch back to the active one
					if target and target.buf ~= active_buf then
						for _, t in ipairs(state.terminals) do
							if t.buf == active_buf then
								utils.switch_buf(active_buf)
								break
							end
						end
					end
				end, { buffer = buf })
			end,
			term = function(buf)
				vim.keymap.set({ "n", "t" }, "<C-\\>", "<cmd>FloatermToggle<cr>", { buffer = buf })
			end,
		},
	},
}
