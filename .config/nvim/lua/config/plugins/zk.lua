return {
  'zk-org/zk-nvim',
  config = function()
    require('zk').setup({
      picker = 'telescope',
      lsp = {
        config = {
          cmd = { 'zk', 'lsp' },
          name = 'zk',
        },
        auto_attach = {
          enabled = true,
          filetypes = { 'markdown' },
        },
      },
    })

    vim.keymap.set('n', '<leader>zn', '<cmd>ZkNew { title = vim.fn.input("Title: ") }<CR>')
    vim.keymap.set('n', '<leader>zo', '<cmd>ZkNotes { sort = { "modified" } }<CR>')
    vim.keymap.set('n', '<leader>zt', '<cmd>ZkTags<CR>')
    vim.keymap.set('n', '<leader>zf', '<cmd>ZkNotes { sort = { "modified" }, match = { vim.fn.input("Search: ") } }<CR>')
    vim.keymap.set('v', '<leader>zn', ":'<,'>ZkNewFromTitleSelection<CR>")
    vim.keymap.set('v', '<leader>zf', ":'<,'>ZkMatch<CR>")
    vim.keymap.set('n', '<leader>zi', '<cmd>edit ~/vault/inbox.md<CR>')
    vim.keymap.set('n', '<leader>zl', '<cmd>ZkInsertLink<CR>')
    vim.keymap.set('v', '<leader>zl', ":'<,'>ZkInsertLinkAtSelection<CR>")
  end
}
