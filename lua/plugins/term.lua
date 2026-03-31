return {
	"nvzone/floaterm",
	dependencies = "nvzone/volt",
	cmd = "FloatermToggle",
	keys = {
		{ "<C-\\>", "<cmd>FloatermToggle<cr>", mode = { "n", "t" }, desc = "Toggle terminal" },
	},
	config = function(_, opts)
		require("floaterm").setup(opts)

		vim.api.nvim_create_autocmd("TermClose", {
			callback = function(args)
				local state = require("floaterm.state")
				if not state.terminals then return end
				local utils = require("floaterm.utils")
				local match = utils.get_term_by_key(args.buf)
				if match then
					vim.schedule(function()
						require("floaterm.api").delete_term(args.buf)
						if vim.api.nvim_buf_is_valid(args.buf) then
							vim.api.nvim_buf_delete(args.buf, { force = true })
						end
						vim.defer_fn(function()
							if state.volt_set and state.buf and vim.api.nvim_buf_is_valid(state.buf)
								and vim.bo[state.buf].buftype == "terminal" then
								vim.api.nvim_set_current_win(state.win)
								vim.cmd.startinsert()
							end
						end, 50)
					end)
				end
			end,
		})
	end,
	opts = {
		size = { h = 80, w = 90 },
		terminals = {
			{ name = "Terminal" },
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
				local api = require("floaterm.api")
				vim.keymap.set({ "n", "t" }, "<C-n>", function() api.new_term({ name = "auto" }) end, { buffer = buf, desc = "New terminal" })
				vim.keymap.set({ "n", "t" }, "<C-r>", function()
					local state = require("floaterm.state")
					local utils = require("floaterm.utils")
					local match = utils.get_term_by_key(state.buf)
					if match then
						vim.ui.input({ prompt = "Rename terminal: " }, function(input)
							if input and #input > 0 then
								match[2].name = input
								require("volt").redraw(state.sidebuf, "bufs")
								require("volt").redraw(state.barbuf, "bar")
							end
						end)
					end
				end, { buffer = buf, desc = "Rename terminal" })
				vim.keymap.set({ "n", "t" }, "<C-d>", function() api.delete_term(require("floaterm.state").buf) end, { buffer = buf, desc = "Delete terminal" })
			end,
		},
	},
}
