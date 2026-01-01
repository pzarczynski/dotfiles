-- Options
vim.g.mapleader = " "
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.undofile = true
vim.opt.clipboard = "unnamedplus"
vim.opt.path = vim.opt.path + "**"

-- Plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = { 
        -- Telescope
        {
            "nvim-telescope/telescope.nvim", 
            tag = "v0.2.0",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
        },

        -- Colorscheme
        {
            "ellisonleao/gruvbox.nvim",
            priority = 1000,
            config = function()
                require("gruvbox").setup({})
            end,
    	},

        -- LSP
        { "neovim/nvim-lspconfig" },
        {
            "williamboman/mason.nvim",
        },
        {
            "williamboman/mason-lspconfig.nvim",
            dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        },
        
        -- Completion
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
            },
        },

        {
            "stevearc/conform.nvim",
            opts = {},
        },

        -- GitHub Copilot
        { "github/copilot.vim" },
        
        -- Treesitter
        {
            "nvim-treesitter/nvim-treesitter",
            branch = "master",
            lazy = false,
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                ensure_installed = { "python", "lua" },
                highlight = { enable = true },
                indent = { enable = true },
                })
            end,
        },

        -- nvim-tree 
        {
            "nvim-tree/nvim-tree.lua",
            version = "*",
            lazy = false,
            dependencies = {
                "nvim-tree/nvim-web-devicons", -- optional icons
            },
            config = function()
                require("nvim-tree").setup({})
            end,
        },
	},
    checker = { enabled = true },
})

-- Colorscheme
vim.opt.termguicolors = true
vim.cmd([[colorscheme gruvbox]])

-- mason
local ok_mason, mason = pcall(require, "mason")
if ok_mason then
    mason.setup()
    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
        ensure_installed = { "pyright" },
        automatic_installation = true,
    })
end

-- nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Pyright
vim.lsp.config("pyright", {
    capabilities = capabilities,
})

-- nvim-cmp setup
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

-- Ruff formatting via conform.nvim
local ok_conform, conform = pcall(require, "conform")
if ok_conform then
  conform.setup({
    formatters_by_ft = {
      python = { "ruff_format", "ruff_organize_imports" },
    },
  })

  -- Keymap: save + format with Ruff
  vim.keymap.set("n", "<leader>f", function()
    vim.cmd("write")
    conform.format({ async = false, lsp_fallback = false })
  end, { desc = "Save and format with Ruff" })
end

-- Keymaps
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>/", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>,", builtin.buffers, { desc = "Telescope buffers" })

vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Telescope LSP references" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc  = "LSP hover" })

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>t", function()
  vim.cmd("split | resize 5")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, { desc = "Open terminal at bottom" })

