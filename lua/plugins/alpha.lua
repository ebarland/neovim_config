return {
	"goolord/alpha-nvim",
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		vim.o.termguicolors = true
		vim.api.nvim_set_hl(0, "MechRobe", { fg = "#d20f39" }) -- red robe
		vim.api.nvim_set_hl(0, "MechMetal", { fg = "#a6adc8" }) -- steel
		vim.api.nvim_set_hl(0, "MechWire", { fg = "#585b70" }) -- dark wire
		vim.api.nvim_set_hl(0, "MechEye", { fg = "#40a02b" }) -- green eyes

		dashboard.section.header.val = {
			"                                                                            								  ",
			"                                                                            								  ",
			"                                                                            								  ",
			"                                                                            								  ",
			"                                                                            								  ",
			"                                                                            								  ",
			"                                                                            								  ",
			"                                                                            								  ",
			"                                                                            								  ",
			"                                                                            ,..........					  ",
			"                                                                         RRRRRRRRRRRRRRRRR				      ",
			"                                                                       RRRRrrrrrrrrRRRRRRRRRR			      ",
			"                                                                     RRRrrrrrrrrrrrrRRRRRRRRRRRR		      ",
			"                                                                    RRRrrrrrrrrrrrrrrRRRRRRRRRRRRR		      ",
			"                                                                  RRRRrrrrrrrrrrrrrrrrRRRRRRRRRRRRRRR	      ",
			"                                                                 RRRRrrrrrrrrrrrrrrrrrrRRRRRRRRRRRRRR	      ",
			"                                                                RRRRrrrrrrrrrrrrrrrrrrrRRRRRRRRRRRRRRR	      ",
			"                                                                RRrrrrrrrrrrrrrrrrrrrrrRRRRRRRRRRRRRRR	      ",
			"                                                               RRRrrrrrrrrrrrrrrrrrrrrrRRRRrrrrRRRRRRR	      ",
			"                                                              RRRrr      rrrrrrrrrrrrrrRRRRrrrrrRRrrrRR	  ",
			"                                                             RR              rrrrrrrrrrrrRRrrrrrRRRrrrR	  ",
			"                                                             RR                 rrrrrrrrrRRrrrrrRrrrRRR	  ",
			"                                                            Rr                     rrrrrrRRRrrrRRrrrrRR	  ",
			"                                                           Rrr    =======     ======   rrrRRrrrRrrrrrrrr     ",
			"                                                          Rrr     =======     ======      rrrrrrrrrrrrrR     ",
			"                                        uhhhh...            RR                             rrrrrrrRRRRRR     ",
			"                                     Can I Help you?        Rr                              rrrrrRRRRRRRR    ",
			"                                                            Rr                                rrrrRRRRRRR    ",
			"                                                           Rrr                           .     rrrRRRRRRRR   ",
			"                                                           Rrr                          GGG       rrrrRRRRR  ",
			"                                                           Rr       GG              ..  GGG  G    rrrrrrrrrr ",
			"                                                           Rr      GG              GGGG GGG  G   rrrrrrrrrrr ",
			"                                                          Rr      GG               GGG\\  GG  G  rrrrrrrrrrrr",
			"                                                          R      GG   GGGg          GGG\\ G   G  rrrrrrRrrrrr",
			"                                                         R    R  GG  GGGg           GGGG     G  rrrrrrRrrrrr ",
			"                                                    ..... R   R  GG  GGg             GGGG   G  rrrRrrrrrRrrr ",
			"                                                  GGGGGG GGG    GG  GGg          g    GGG  G  rrrRrrrrrRrrrr ",
			"                                                 GGGGrrrGGGGrr  GG GGG           GG    GGG   rrrrrrrrrrrrrrr ",
			"                                                rGGGGrrrGGGGrrr   GGg  g        GG      GGG  rrrrrrrrrrrrrrr ",
			"                                                rGGGrrrrrGGGrrr  GGG   g        GG      GGGGG rrrrrrrrrrrrrr ",
			"                                            .gGrrGGGrrrrrGGGrrrGGGG    g  g     GG   g g  GGGG rrrrrrrrrrrrr ",
			"                                        .gGGGGrrrGGGrrrrrrGGGrrGGG  G   G  g    GG  g   g   GGGG  rrrrrrrrrr ",
			"                                      .gGGGGGrrrrGGGrrrrrrrG GGGG    G   G  g  GG  g     g     GGGG    rrrrr ",
			"                                   .gGGGGGGGrrrrrrGGGrrrrrrGGGG   g   G   G  g GG  g      g       GGGGGGGGGG ",
			"                                 .gGGGGGGGGrrrrrrrGGGGGGGGGGG     g     G  G  gGG  g        g          GGGGG ",
			"                               .gGGGGGGGGG rrrrrrrrr gGGGg        g      G  G gGG  G       g--g--g--g   rrrr ",
			"                             .gGGGGGGGGG  rrrrrrrrrrrrrrrr        g       G  G     G       g 100110 g rrrrrr ",
			"                           .gGGGGGGGGG   rrrrrrrrrrrrrrrr         g        G G     G       g 011011 g rrrrrr ",
			"                          .GGGGGGGGGG    rrrrrrrrrrrrrrrr         g g      G  G    G       g--g--g--g rrrrrr ",
			"-------------------------------------------------------------------------------------------------------------",
		}

		local lines = dashboard.section.header.val
		dashboard.section.header.opts.hl = {}
		for i = 1, #lines do
			-- fill each entire line as robe-red by default (optional)
			dashboard.section.header.opts.hl[i] = { { "MechRobe", 0, -1 } }
		end

		local function paint(line, c0, c1, group)
			table.insert(dashboard.section.header.opts.hl[line], { group, c0, c1 })
		end
		local function paint_char(line, col, group) paint(line, col, col + 1, group) end
		local function paint_len(line, col, len, group) paint(line, col, col + len, group) end

		-- eyes
		paint_len(24, 66, 7, "MechEye")
		paint_len(25, 66, 7, "MechEye")
		paint_len(24, 78, 6, "MechEye")
		paint_len(25, 78, 6, "MechEye")

		paint_len(28, 63, 31, "MechMetal")
		paint_len(29, 63, 31, "MechMetal")
		paint_len(30, 63, 31, "MechMetal")
		paint_len(31, 63, 31, "MechMetal")
		paint_len(32, 63, 31, "MechMetal")
		paint_len(33, 63, 31, "MechMetal")
		paint_len(34, 63, 31, "MechMetal")
		paint_len(35, 63, 31, "MechMetal")
		paint_len(36, 63, 31, "MechMetal")
		paint_len(37, 63, 31, "MechMetal")
		paint_len(38, 63, 31, "MechMetal")
		paint_len(39, 63, 31, "MechMetal")
		paint_len(40, 60, 31, "MechMetal")
		paint_len(41, 63, 34, "MechMetal")
		paint_len(42, 58, 3, "MechMetal")
		paint_len(43, 58, 3, "MechMetal")
		paint_len(44, 58, 3, "MechMetal")

		-- paint_len(29, 58, 3, "MechMetal")

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
			)
		}

		-- FOOTER (stats)
		local function footer()
			local stats = require("lazy").stats()
			local ms = tostring(math.floor(stats.startuptime)) .. " ms"
			return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
		end
		dashboard.section.footer.val      = footer()

		-- Optional highlights
		dashboard.section.buttons.opts.hl = "Keyword"
		dashboard.section.footer.opts.hl  = "Comment"

		-- Optional: reapply palette after colorscheme changes
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.api.nvim_set_hl(0, "MechRobe", { fg = "#d20f39" })
				vim.api.nvim_set_hl(0, "MechMetal", { fg = "#a6adc8" })
				vim.api.nvim_set_hl(0, "MechWire", { fg = "#585b70" })
				vim.api.nvim_set_hl(0, "MechEye", { fg = "#40a02b" })
			end,
		})

		-- If you want the footer to update after Lazy finishes:
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				dashboard.section.footer.val = footer()
				pcall(vim.cmd.AlphaRedraw)
			end,
		})

		vim.api.nvim_create_autocmd("UIEnter", {
			once = true,
			callback = function()
				vim.defer_fn(function()
					local alpha = require("alpha")
					alpha.setup(dashboard.opts)
					if vim.fn.argc(-1) == 0 and vim.api.nvim_buf_get_name(0) == "" then
						alpha.start(true)
					end
				end, 500) -- 0.5s
			end,
		})
	end
}
