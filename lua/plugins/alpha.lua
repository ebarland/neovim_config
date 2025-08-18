-- lua/plugins/alpha.lua
return {
	"goolord/alpha-nvim",
	-- dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- --- Stealth Alpha: no flicker, full restore ---

		-- (Optional) patch lualine to ignore alpha buffers
		pcall(function()
			local ok, lualine = pcall(require, "lualine")
			if not ok or not lualine.get_config then return end
			local cfg = lualine.get_config()
			cfg.options = cfg.options or {}
			cfg.options.disabled_filetypes = cfg.options.disabled_filetypes or {}
			local df = cfg.options.disabled_filetypes
			local function ensure_alpha_in(t)
				for _, ft in ipairs(t) do if ft == "alpha" then return end end
				table.insert(t, "alpha")
			end
			if df.statusline then
				ensure_alpha_in(df.statusline) -- lualine v3 format
			elseif vim.tbl_islist(df) then
				ensure_alpha_in(df) -- older flat list format
			else
				cfg.options.disabled_filetypes = { statusline = { "alpha" } }
			end
			lualine.setup(cfg)
		end)

		-- Hide ASAP on clean startup (no args, empty buffer)
		vim.api.nvim_create_autocmd("UIEnter", {
			once = true,
			callback = function()
				if vim.fn.argc(-1) == 0 and vim.api.nvim_buf_get_name(0) == "" then
					vim.opt.laststatus = 0
					vim.opt.ruler = false
					vim.opt.showcmd = false
				end
			end,
		})

		-- Safety net: if Alpha signals ready, keep things hidden
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function()
				vim.opt.laststatus = 0
				vim.opt.ruler = false
				vim.opt.showcmd = false
			end,
		})

		-- Main logic: enter alpha -> hide; leave alpha -> restore
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function(args)
				-- Save current user prefs to restore later
				local saved = {
					laststatus = vim.o.laststatus,
					ruler      = vim.o.ruler,
					showcmd    = vim.o.showcmd,
				}

				-- Hide everything during alpha
				vim.opt.laststatus = 0
				vim.opt.ruler = false
				vim.opt.showcmd = false

				-- Restore when the alpha buffer goes away
				vim.api.nvim_create_autocmd({ "BufWipeout", "BufUnload", "BufLeave" }, {
					buffer = args.buf,
					once = true,
					callback = function()
						vim.opt.laststatus = saved.laststatus
						vim.opt.ruler = saved.ruler
						vim.opt.showcmd = saved.showcmd
					end,
				})
			end,
		})

		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local art = require("user.art")


		-- Colors
		vim.o.termguicolors = true
		vim.api.nvim_set_hl(0, "MechRobe", { fg = "#d20f39" }) -- robe (default fill)
		vim.api.nvim_set_hl(0, "MechMetal", { fg = "#a6adc8" }) -- steel (G)
		vim.api.nvim_set_hl(0, "MechWire", { fg = "#585b70" }) -- wire (g)
		vim.api.nvim_set_hl(0, "MechEye", { fg = "#40a02b" }) -- eyes (=)
		vim.api.nvim_set_hl(0, "MechWhite", { fg = "#1fa28b" }) -- eyes (=)

		-- Get lines + auto-inferred highlight ranges from art.lua
		local lines, ranges = art.render()
		dashboard.section.header.val = lines

		-- Default per-line fill (robe red), then overlay inferred ranges
		dashboard.section.header.opts.hl = {}
		for i = 1, #lines do
			dashboard.section.header.opts.hl[i] = { { "MechRobe", 0, -1 } }
		end

		local function add_range(group, li, c0, c1)
			table.insert(dashboard.section.header.opts.hl[li], { group, c0, c1 })
		end

		for group, per_line in pairs(ranges or {}) do
			for li, segs in pairs(per_line) do
				for _, seg in ipairs(segs) do
					add_range(group, li, seg[1], seg[2])
				end
			end
		end

		-- Buttons
		dashboard.section.buttons.val = {
			dashboard.button("ff", "  Find File", ":Telescope find_files<CR>"),
			dashboard.button("fo", "  Recent Files", ":Telescope oldfiles<CR>"),
			dashboard.button("fw", "󰈭  Find Word", ":Telescope live_grep<CR>"),
			dashboard.button("th", "󱥚  Themes", ":lua require('nvchad.themes').open()<CR>"),
			dashboard.button("ch", "  Mappings", ":NvCheatsheet<CR>"),
			dashboard.button("cc", "  Config",
				":cd " ..
				vim.fn.stdpath("config") .. " | NvimTreeClose | NvimTreeOpen " .. vim.fn.stdpath("config") .. "<CR>"
			),
			dashboard.button("cd", "  Dev folder",
				":cd C:\\\\Development\\\\Git\\\\Private | NvimTreeClose | NvimTreeOpen C:\\\\Development\\\\Git\\\\Private<CR>"
			),
		}

		-- Footer (stats)
		local function footer()
			local stats = require("lazy").stats()
			local ms = tostring(math.floor(stats.startuptime)) .. " ms"
			return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
		end
		dashboard.section.footer.val      = footer()

		-- Optional highlights
		dashboard.section.buttons.opts.hl = "Keyword"
		dashboard.section.footer.opts.hl  = "Comment"

		-- Reapply palette after colorscheme changes
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.api.nvim_set_hl(0, "MechRobe", { fg = "#d20f39" })
				vim.api.nvim_set_hl(0, "MechMetal", { fg = "#a6adc8" })
				vim.api.nvim_set_hl(0, "MechWire", { fg = "#585b70" })
				vim.api.nvim_set_hl(0, "MechEye", { fg = "#40a02b" })
			end,
		})

		-- Update footer after Lazy finishes
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				dashboard.section.footer.val = footer()
				pcall(vim.cmd.AlphaRedraw)
			end,
		})

		-- Setup on UI enter (with slight delay)
		vim.api.nvim_create_autocmd("UIEnter", {
			once = true,
			callback = function()
				vim.defer_fn(function()
					alpha.setup(dashboard.opts)
					if vim.fn.argc(-1) == 0 and vim.api.nvim_buf_get_name(0) == "" then
						alpha.start(true)
					end
				end, 200) -- 0.5s
			end,
		})
	end,
}
