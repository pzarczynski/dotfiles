vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>")

vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "K", vim.lsp.buf.hover)

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

vim.keymap.set("v", "<Tab>",   ">gv", { silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { silent = true })

vim.keymap.set("i", ",", ",<C-g>u")
vim.keymap.set("i", ".", ".<C-g>u")
vim.keymap.set("i", "<C-u>", "<Esc>ui", { noremap = true, silent = true })

