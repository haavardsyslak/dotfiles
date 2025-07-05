vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("custom-term-open", {}),
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.scrolloff = 0
		vim.keymap.set("t", "<esc>", "<c-\\><c-n>")
        vim.bo.filetype = "terminal"
    end,
})
