-- lua/plugins/crates.lua
return {
	"saecki/crates.nvim",
	event = "BufRead Cargo.toml",
	opts = {
		completion = {
			cmp = { enabled = false },
			crates = { enabled = true },
		},
		lsp = {
			enabled = true,
			actions = true,
			completion = true,
			hover = true,
		},
	},
	config = function(_, opts)
		local crates = require("crates")
		crates.setup(opts)

		local map = vim.keymap.set
		map("n", "<leader>ci", crates.show_crate_popup, { desc = "Crate info" })
		map("n", "<leader>cv", crates.show_versions_popup, { desc = "Crate versions" })
		map("n", "<leader>cf", crates.show_features_popup, { desc = "Crate features" })
		map("n", "<leader>cd", crates.show_dependencies_popup, { desc = "Crate dependencies" })
		map("n", "<leader>cu", crates.upgrade_crate, { desc = "Upgrade crate" })
		map("n", "<leader>cU", crates.upgrade_all_crates, { desc = "Upgrade all crates" })
	end,
}
