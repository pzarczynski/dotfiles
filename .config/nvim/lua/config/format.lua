local ok_conform, conform = pcall(require, "conform")
if ok_conform then
    conform.setup({ 
        formatters_by_ft = { python = { "ruff_format", "ruff_organize_imports" } }
    })

    vim.keymap.set("n", "<C-s>", function()
        vim.cmd("write")
        conform.format({ async = false, lsp_fallback = false })
    end)
end
