return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  ft = { 'org' },
  config = function()
    require('orgmode').setup({
      org_agenda_files = '~/vault/org/**/*',
      org_default_notes_file = '~/vault/org/refile.org',
      org_todo_keywords = { 'TODO(t)', 'NEXT(n)', 'WAITING(w)', '|', 'DONE(d)', 'CANCELLED(c)' },
      org_capture_templates = {
        t = {
          description = 'Task',
          template = '* TODO %?\n  %u',
          target = '~/vault/org/refile.org',
        },
        p = {
          description = 'Project',
          template = '* PROJECT %?                                                       :project:\n  Notes:\n  -\n',
          target = '~/vault/org/projects.org',
        },
      },
    })

    vim.keymap.set('n', '<leader>oa', '<cmd>lua require("orgmode").action("agenda.prompt")<CR>', { desc = 'Org agenda' })
    vim.keymap.set('n', '<leader>oc', '<cmd>lua require("orgmode").action("capture.prompt")<CR>',
      { desc = 'Org capture' })
    vim.keymap.set('n', '<leader>oR', '<cmd>edit ~/vault/org/refile.org<CR>', { desc = 'Open org refile' })
    vim.keymap.set('n', '<leader>oP', '<cmd>edit ~/vault/org/projects.org<CR>', { desc = 'Open org projects' })
  end,
}
