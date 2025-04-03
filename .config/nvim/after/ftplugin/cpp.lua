vim.opt_local.expandtab = true
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = { '*.cpp', '*.hpp' },
    callback = function()
        vim.cmd('silent! !clang-format -i %')
    end,
    desc = 'Run clang-format on save for .cpp and .hpp files in the specific directory',
})
