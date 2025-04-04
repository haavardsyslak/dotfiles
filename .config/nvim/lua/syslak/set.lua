vim.opt.nu = true

vim.opt.relativenumber = true

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.smartindent = true

vim.opt.wrap = false

-- vim.opt.syntax = "enable"

vim.opt.termguicolors = true

vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.textwidth = 99

vim.opt.pumheight = 10
vim.opt.completeopt = { "menu", "menuone", "noselect" }
--  vim.opt.conceallevel = 0
--
vim.bo.formatoptions = vim.bo.formatoptions:gsub("t", "")
vim.opt.cmdheight = 0

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

vim.cmd("filetype plugin indent on")

vim.api.nvim_create_user_command("W", "w", {})


-- Set local settings for terminal buffers
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
