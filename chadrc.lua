-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

local config_dir = vim.fn.stdpath "config"

M.base46 = {
  theme = "chadracula",

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

M.nvdash = {
  load_on_startup = true,
  header = {
    "                                                                            ,..........						         ",
    "                                                                         RRRRRRRRRRRRRRRRR				           ",
    "                                                                       RRRRrrrrrrrrRRRRRRRRRR			         ",
    "                                                                     RRRrrrrrrrrrrrrRRRRRRRRRRRR		         ",
    "                                                                    RRRrrrrrrrrrrrrrrRRRRRRRRRRRRR		       ",
    "                                                                  RRRRrrrrrrrrrrrrrrrrRRRRRRRRRRRRRRR	     ",
    "                                                                 RRRRrrrrrrrrrrrrrrrrrrRRRRRRRRRRRRRR	     ",
    "                                                                RRRRrrrrrrrrrrrrrrrrrrrRRRRRRRRRRRRRRR	     ",
    "                                                                RRrrrrrrrrrrrrrrrrrrrrrRRRRRRRRRRRRRRR	     ",
    "                                                               RRRrrrrrrrrrrrrrrrrrrrrrRRRRrrrrRRRRRRR	     ",
    "                                                              RRRrr      rrrrrrrrrrrrrrRRRRrrrrrRRrrrRR	   ",
    "                                                             RR              rrrrrrrrrrrrRRrrrrrRRRrrrR	   ",
    "                                                             RR                 rrrrrrrrrRRrrrrrRrrrRRR	   ",
    "                                                            Rr                     rrrrrrRRRrrrRRrrrrRR	   ",
    "                                                           Rrr    =======     ======   rrrRRrrrRrrrrrrrr    ",
    "                                                          Rrr     =======     ======      rrrrrrrrrrrrrR    ",
    "                                        uhhhh...            RR                             rrrrrrrRRRRRR    ",
    "                                     Can I Help you?        Rr                              rrrrrRRRRRRRR   ",
    "                                                            Rr                                rrrrRRRRRRR   ",
    "                                                           Rrr                           .     rrrRRRRRRRR  ",
    "                                                           Rrr                          GGG       rrrrRRRRR ",
    "                                                           Rr       GG              ..  GGG  G    rrrrrrrrrr",
    "                                                           Rr      GG              GGGG GGG  G   rrrrrrrrrrr",
    "                                                          Rr      GG               GGG\\  GG  G  rrrrrrrrrrrr",
    "                                                          R      GG   GGGg          GGG\\ G   G  rrrrrrRrrrrr",
    "                                                         R    R  GG  GGGg           GGGG     G  rrrrrrRrrrrr",
    "                                                    ..... R   R  GG  GGg             GGGG   G  rrrRrrrrrRrrr",
    "                                                  GGGGGG GGG    GG  GGg          g    GGG  G  rrrRrrrrrRrrrr",
    "                                                 GGGGrrrGGGGrr  GG GGG           GG    GGG   rrrrrrrrrrrrrrr",
    "                                                rGGGGrrrGGGGrrr   GGg  g        GG      GGG  rrrrrrrrrrrrrrr",
    "                                                rGGGrrrrrGGGrrr  GGG   g        GG      GGGGG rrrrrrrrrrrrrr",
    "                                            .gGrrGGGrrrrrGGGrrrGGGG    g  g     GG   g g  GGGG rrrrrrrrrrrrr",
    "                                        .gGGGGrrrGGGrrrrrrGGGrrGGG  G   G  g    GG  g   g   GGGG  rrrrrrrrrr",
    "                                      .gGGGGGrrrrGGGrrrrrrrG GGGG    G   G  g  GG  g     g     GGGG    rrrrr",
    "                                   .gGGGGGGGrrrrrrGGGrrrrrrGGGG   g   G   G  g GG  g      g       GGGGGGGGGG",
    "                                 .gGGGGGGGGrrrrrrrGGGGGGGGGGG     g     G  G  gGG  g        g          GGGGG",
    "                               .gGGGGGGGGG rrrrrrrrr gGGGg        g      G  G gGG  G       g--g--g--g   rrrr",
    "                             .gGGGGGGGGG  rrrrrrrrrrrrrrrr        g       G  G     G       g 100110 g rrrrrr",
    "                           .gGGGGGGGGG   rrrrrrrrrrrrrrrr         g        G G     G       g 011011 g rrrrrr",
    "                          .GGGGGGGGGG    rrrrrrrrrrrrrrrr         g g      G  G    G       g--g--g--g rrrrrr",
    "------------------------------------------------------------------------------------------------------------",
  },

  buttons = {
    { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
    { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
    { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
    { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
    { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },
    { txt = "𓂿  Config", keys = "cc", cmd = ":cd " .. config_dir .. "<CR>:NvimTreeFocus<CR>" },
    { txt = "𓅷  Dev folder", keys = "cd", cmd = ":cd C:\\Development\\Git\\Private<CR>:NvimTreeFocus<CR>" },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "NvDashFooter",
      no_gap = true,
    },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
  },
}

return M
