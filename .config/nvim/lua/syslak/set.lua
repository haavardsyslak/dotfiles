vim.opt.nu = true

vim.opt.relativenumber = true

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.smartindent = true

-- vim.opt.syntax = "enable"

vim.opt.termguicolors = true

vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.textwidth = 99

vim.opt.pumheight = 10
vim.opt.completeopt = { "menu", "menuone", "noselect" }
--  vim.opt.conceallevel = 0

-- vim.g.vimtex_view_method = "zathura"

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    underline = false,
    severity_sort = true,
    float = false,
})


vim.cmd("autocmd BufRead,BufNewFile *.h set filetype=c")
