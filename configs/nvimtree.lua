local nvim_tree_api = require("nvim-tree.api")

local function my_on_attach(bufnr)
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  nvim_tree_api.config.mappings.default_on_attach(bufnr)
  vim.keymap.set("n", "<C-o>", nvim_tree_api.tree.change_root_to_node, opts("CD"))
  vim.keymap.set("n", "<C-u>", nvim_tree_api.tree.change_root_to_parent, opts("Up"))
end

local options = {
  on_attach = my_on_attach,
  actions = {
    open_file = {
      resize_window = true,
    },
    change_dir = {
      global = true
    }
  }
}

return options
