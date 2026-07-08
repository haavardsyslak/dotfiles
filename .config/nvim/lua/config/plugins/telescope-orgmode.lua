return {
  'nvim-orgmode/telescope-orgmode.nvim',
  dependencies = {
    'nvim-orgmode/orgmode',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('telescope').load_extension('orgmode')

    vim.keymap.set('n', '<leader>oh', function()
      require('telescope').extensions.orgmode.search_headings()
    end, { desc = 'Org search headings' })
    vim.keymap.set('n', '<leader>ot', function()
      require('telescope').extensions.orgmode.search_tags()
    end, { desc = 'Org search tags' })
    vim.keymap.set('n', '<leader>oF', function()
      require('telescope').extensions.orgmode.refile_heading()
    end, { desc = 'Org refile (telescope)' })
  end,
}
