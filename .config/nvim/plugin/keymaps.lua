local set = vim.keymap.set

-- Navigation
set("n", "<Leader>wl", "<C-w>l")
set("n", "<Leader>wh", "<C-w>h")
set("n", "<Leader>wj", "<C-w>j")
set("n", "<Leader>wk", "<C-w>k")
set("n", "<Leader>w=", "<C-w>=")


-- close and split
set("n", "<Leader>wd", ":close<CR>")
set("n", "<Leader>wv", ":vsplit ")
set("n", "<Leader>ws", ":split ")

 -- Quicker window resize
vim.keymap.set("n", "<C-A-h>", "<C-w><")
vim.keymap.set("n", "<C-A-l>", "<C-w>>")
vim.keymap.set("n", "<C-A-k>", "<C-w>-")
vim.keymap.set("n", "<C-A-j>", "<C-w>+")

-- Clear searches with æ
vim.keymap.set("n", "æ", ":noh<return>")


