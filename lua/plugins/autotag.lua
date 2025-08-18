-- lua/plugins/autotag.lua
return {
	"windwp/nvim-ts-autotag",
	event = "InsertEnter",
	ft = { "html", "javascriptreact", "typescriptreact", "vue", "svelte", "astro" },
	opts = {}
}
