local ok_mason, mason = pcall(require, "mason")
if ok_mason then
    mason.setup()
    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
        ensure_installed = { "pyright", "neocmake", "clangd" },
        automatic_installation = true,
    })
end

-- nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- pyright
vim.lsp.config("pyright", { capabilities = capabilities })

-- cmake
vim.lsp.config("neocmakelsp", {
    capabilities = capabilities,
    cmd = { "neocmakelsp", "--stdio" },
    root_dir = function(fname)
        return util.root_pattern(
            "CMakePresets.json",
            "CTestConfig.cmake",
            ".git",
            "build",
            "cmake"
        )(fname)
    end,
    filetypes = { "cmake" },
})
vim.lsp.enable("neocmake")

vim.lsp.config("clangd", {
    cmd = { "clangd" }, filetypes = { "c", "cpp", "objc", "objcpp" },
})

local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
    }),
})

