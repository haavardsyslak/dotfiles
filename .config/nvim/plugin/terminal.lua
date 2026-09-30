vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", {}),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
    -- Double Esc leaves terminal mode; a single Esc still reaches TUIs (lazygit, Pi).
    vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { buffer = true, desc = "Exit terminal mode" })
    vim.bo.filetype = "terminal"
  end,
})
