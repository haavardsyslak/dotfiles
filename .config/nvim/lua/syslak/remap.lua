vim.g.mapleader =  " "


-- Autoclose
-- vim.keymap.set("i", "'", "''<left>")
-- vim.keymap.set("i", '"', '""<left>')
-- vim.keymap.set("i", "(", "()<left>")
-- vim.keymap.set("i", "[", "[]<left>")
-- vim.keymap.set("i", "{", "{}<left>")
-- vim.keymap.set("i", "{<CR>", "{<CR>}<ESC>O")
-- vim.keymap.set("i", "{;<CR>", "{<CR>};<ESC>O")

-- Navigation
vim.keymap.set("n", "<Leader>wl", "<C-w>l")
vim.keymap.set("n", "<Leader>wh", "<C-w>h")
vim.keymap.set("n", "<Leader>wj", "<C-w>j")
vim.keymap.set("n", "<Leader>wk", "<C-w>k")
vim.keymap.set("n", "<Leader>w=", "<C-w>=")


vim.keymap.set("n", "<Leader>wd", ":close<CR>")
vim.keymap.set("n", "<Leader>wv", ":vsplit ")
vim.keymap.set("n", "<Leader>ws", ":split ")
 --
 -- Quicker window resize
vim.keymap.set("n", "<C-A-h>", "<C-w><")
vim.keymap.set("n", "<C-A-l>", "<C-w>>")
vim.keymap.set("n", "<C-A-k>", "<C-w>-")
vim.keymap.set("n", "<C-A-j>", "<C-w>+")

-- Clear searches with æ
vim.keymap.set("n", "æ", ":noh<return>")

 --nnoremap <silent> Q <nop> 

 -- Lazy Fat fingers
 --command -complete=file -bang -nargs=? Q  :q<bang> <args>
 --command -complete=file -bang -nargs=? W  :w<bang> <args>
 --command -complete=file -bang -nargs=? Wq :wq<bang> <args>
 --
 --"  Kem bruke piltastane uansett?
vim.keymap.set("n", "<Up>", "<Nop>")
vim.keymap.set("n", "<Down>", "<Nop>")
vim.keymap.set("n", "<Left>", "<Nop>")
vim.keymap.set("n", "<Right>", "<Nop>")

--inoremap <A-f> <Esc>/<++><enter>"_c4l

-- Terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
-- vim.keymap.set("n", "<Leader>ot", ":split<Cr><C-w>j:term<Cr>")

vim.keymap.set("n", "<leader>op", ":lua pdf_open()<CR>", { noremap = true, silent = true })

vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Floting diagnostics message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, { desc = 'Goto prev diagnostics message' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_next, { desc = 'Goto prev diagnostics message' })


-- require("syslak.better_bd")
-- vim.keymap.set('n', '<leader>bd', ":Betterbd<CR>")

vim.keymap.set("i", "<F1>", "<Esc>")

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("custom-term-open", {}),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.scrolloff = 0

        vim.bo.filetype = "terminal"
    end,
})


-- Easily hit escape in terminal mode.
-- vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set("n", "<Leader>ot", function()
    vim.cmd.new()
    vim.cmd.wincmd "J"
    vim.api.nvim_win_set_height(0, 12)
    vim.wo.winfixheight = true
    vim.cmd.term()
end)



vim.keymap.set('n', '<C-n>', ':bnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-p>', ':bprev<CR>', { noremap = true, silent = true })
