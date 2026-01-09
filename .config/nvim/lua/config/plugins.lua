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
        -- colorscheme
        {
            "ellisonleao/gruvbox.nvim",
            priority = 1000,
            config = function()
                require("gruvbox").setup({ contrast = "hard" })     
                vim.o.background = "dark"
                vim.cmd([[colorscheme gruvbox]])
            end,
    	},

        -- LSP
        { "neovim/nvim-lspconfig" },
        { "williamboman/mason.nvim" },
        {
            "williamboman/mason-lspconfig.nvim",
            dependencies = { 
                "williamboman/mason.nvim", 
                "neovim/nvim-lspconfig" 
            },
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

        { "stevearc/conform.nvim", opts = {} },

        -- treesitter
        {
            "nvim-treesitter/nvim-treesitter",
            branch = "master",
            lazy = false,
            build = ":TSUpdate",
            config = function()
                require("nvim-treesitter.configs").setup({
                    ensure_installed = { "python", "lua", "bash", "json", "toml", "markdown" },
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end,
        },

        -- File explorer
        {
            "nvim-tree/nvim-tree.lua",
            version = "*",
            lazy = false,
            dependencies = { "nvim-tree/nvim-web-devicons" },       
            config = function()
                require("nvim-tree").setup({})
            end
        },
        
        -- Terminal
        {
            "akinsho/toggleterm.nvim",
            version = "*",
            config = function()
            require("toggleterm").setup({
                size = 60,
                open_mapping = [[<C-/>]],
                direction = "vertical",
                shade_terminals = true,
                persist_size = true,
                persist_mode = true,
            })
            end,
        },

        {
            "nvim-lualine/lualine.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                require("lualine").setup({ options = { theme = "gruvbox" } })
            end,
        },
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.6",
            dependencies = { "nvim-lua/plenary.nvim" },
        }
    },
    checker = { enabled = true },
})

