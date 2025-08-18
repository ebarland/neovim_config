-- lua/plugins/art.lua
-- Pure ASCII art + an auto-highlighter that infers colors from characters:
--   r/R -> Robe (default fill; we won't record ranges for these)
--   =   -> Eyes (MechEye)
--   G   -> Steel (MechMetal)
--   g   -> Wires (MechWire)
--
-- Exposes:
--   art.render() -> lines, ranges
--     lines  : string[] (unchanged from raw)
--     ranges : { [hl_group] = { [line_index] = { {c0, c1}, ... } } }
--   art.tagged() -> tagged_lines (optional helper that returns a version with <<E>>, <<S>>, <<W>>)

local M = {}

-- Raw ASCII lines (no tags!)
M.raw = {
	"                                                                            								  ",
	"                                                                            								  ",
	"                                                                            								  ",
	"                                                                            								  ",
	"                                                                            								  ",
	"                                                                           ....xxxxxx...					  ",
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
	"                                     Can I help you?        Rr                              rrrrrRRRRRRRR    ",
	"                                                            Rr                                rrrrRRRRRRR    ",
	"                                                           Rrr                           g     rrrRRRRRRRR   ",
	"                                                           Rrr                      g    ggg      rrrrRRRRR  ",
	"                                                           Rr       gg              gg  gGg  g    rrrrrrrrrr ",
	"                                                           Rr      gg              gGgg GGG  g   rrrrrrrrrrr ",
	"                                                          Rr      Gg    gg         gGGg  GG  G  rrrrrrrrrrrr ",
	"                                                          R      GG   GGGg          GGGg G   G  rrrrrrRrrrrr ",
	"                                                         R    R  GG  GGGg       g   GGGG     G  rrrrrrRrrrrr ",
	"                                                    ggg.. R   R  GG  GGg         g   GGGG   G  rrrRrrrrrRrrr ",
	"                                                  GGGgrrrRrr    GG  GGg          g    GGG  G  rrrRrrrrrRrrrr ",
	"                                                 GGGGrrrrRRRrr  GG GGG           GG    GGG   rrrrrrrrrrrrrrr ",
	"                                                rGGGGrrrrRRRrrr   GGg  g        GG      GGG  rrrrrrrrrrrrrrr ",
	"                                                rGGGrrrrrRRRrrr  GGG   g        GG      GGGGG rrrrrrrrrrrrrr ",
	"                                            ,gGrrGGGrrrrrRRRrrrGGGG    g  g     GG   g g  GGGG rrrrrrrrrrrrr ",
	"                                        ,gGGGGrrrGGGrrrrrrRRRrrGGG  G   G  g    GG  g   g   GGGG  rrrrrrrrrr ",
	"                                      ,gGGGGGrrrrGGGrrrrrrrR GGGG    G   G  g  GG  g     g     GGGG    rrrrr ",
	"                                   ,gGGGGGGGrrrrrrGGGrrrrrrGGGG   g   G   G  g GG  g      g       GGGGGGGGGG ",
	"                                 ,gGGGGGGGGrrrRrrrGGGGGGGGGGG     g     G  G  gGG  g        g          GGGGG ",
	"                               ,gGGGGGGGGG rrrRRrrrr gGGGg        g      G  G gGG  G       -||-------   rrrr ",
	"                             ,gGGGGGGGGG  rrrrRRRrrrrrggrr        g       G  G     G       | 100110 | rrrrrr ",
	"                           ,gGGGGGGGGG   rrrrrrrRRRrrrrrr         g        G G     G       | 011011 | rrrrrr ",
	"                          ,GGGGGGGGGG    rrrrrrRRRRrrrrrr         g g      G  G    G       ---------- rrrrrr ",
	"-------------------------------------------------------------------------------------------------------------",
}

-- Character -> highlight group mapping
local char_to_group = {
	["="] = "MechEye",
	["1"] = "MechEye",
	["0"] = "MechEye",
	["G"] = "MechMetal",
	[","] = "MechWire",
	["g"] = "MechWire",
	["-"] = "MechWire",
	["|"] = "MechWire",
	-- r/R intentionally omitted: default robe fill handles them
}

local phrase_to_group = {
	["uhhhh..."] = "MechWhite",
	["Can I help you?"] = "MechWhite",
}

-- Single-letter tag mapping for optional tagged export
local group_to_tag = {
	MechEye   = "E",
	MechMetal = "S", -- Steel
	MechWire  = "W",
	-- MechRobe would be "R", but we don't tag robe since it's the default fill
}

-- One-pass run-length scan that builds highlight ranges for a given line
local function scan_line_for_ranges(line)
	local ranges = {} -- { [group] = { {c0, c1}, ... } }
	local current_group = nil
	local run_start = 0 -- 0-based column start
	local col = 0    -- 0-based column cursor

	local len = #line
	local i = 1 -- Lua string index (1-based)

	local function flush_run()
		if current_group then
			ranges[current_group] = ranges[current_group] or {}
			table.insert(ranges[current_group], { run_start, col })
		end
		current_group = nil
	end

	while i <= len do
		local ch = line:sub(i, i)
		local grp = char_to_group[ch] -- nil if default robe or other char

		if grp ~= current_group then
			flush_run()
			if grp then
				current_group = grp
				run_start = col
			end
		end

		-- advance
		col = col + 1
		i = i + 1
	end

	flush_run()
	return ranges
end

function M.render()
	local lines = {}
	local ranges_by_group = {}

	for li, line in ipairs(M.raw) do
		lines[li] = line

		-- First pass: character-based scan
		local per_group = scan_line_for_ranges(line)
		for group, segs in pairs(per_group) do
			ranges_by_group[group] = ranges_by_group[group] or {}
			ranges_by_group[group][li] = ranges_by_group[group][li] or {}
			vim.list_extend(ranges_by_group[group][li], segs)
		end

		-- Second pass: phrase-based scan
		for phrase, group in pairs(phrase_to_group) do
			local start = 1
			while true do
				local s, e = line:find(phrase, start, true) -- plain find
				if not s then break end
				ranges_by_group[group] = ranges_by_group[group] or {}
				ranges_by_group[group][li] = ranges_by_group[group][li] or {}
				table.insert(ranges_by_group[group][li], { s - 1, e }) -- 0-based start
				start = e + 1
			end
		end
	end

	return lines, ranges_by_group
end

-- Optional: return a **tagged** version of the art using <<E>>, <<S>>, <<W>>
-- (Useful if you want to export or inspect the auto-tagger output.)
function M.tagged()
	local tagged = {}

	for _, line in ipairs(M.raw) do
		local out = {}
		local current_tag = nil

		local function open_tag(tag)
			if tag and tag ~= current_tag then
				if current_tag then table.insert(out, ("<</%s>>"):format(current_tag)) end
				table.insert(out, ("<<%s>>"):format(tag))
				current_tag = tag
			elseif not tag and current_tag then
				table.insert(out, ("<</%s>>"):format(current_tag))
				current_tag = nil
			end
		end

		for i = 1, #line do
			local ch = line:sub(i, i)
			local grp = char_to_group[ch]
			local tag = grp and group_to_tag[grp] or nil
			open_tag(tag)
			table.insert(out, ch)
		end
		open_tag(nil) -- close at EOL

		table.insert(tagged, table.concat(out))
	end

	return tagged
end

return M
