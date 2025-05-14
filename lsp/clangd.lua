return {
  cmd = { "clangd", "--pch-storage=memory", "--background-index" },
  root_markers = { 'compile_commands.json', 'compile_flags.txt' },
  filetypes = { 'c', 'cpp' },
  flags = {
        debounce_text_changes = 100,  -- Faster updates; adjust if too aggressive
    },
    -- Optional: Customize diagnostics display behavior
    on_attach = function(client, bufnr)
        -- Example: Disable diagnostics while typing
        vim.diagnostic.config({
            update_in_insert = true,
            severity_sort = true,
        })
    end,
}
