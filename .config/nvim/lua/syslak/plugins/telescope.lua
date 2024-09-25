return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },

  config = function()
    local builtin = require('telescope.builtin')
    vim.keymap.set("n", "<leader>.", builtin.find_files, {})
    vim.keymap.set("n", "<leader>,", builtin.oldfiles, {})
    -- vim.keymap.set("n", "<leader>," builtin.oldfiles, {})
    vim.keymap.set("n", "<leader><leader>", builtin.buffers, {})
    vim.keymap.set("n", "<leader>sd", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>sc", builtin.command_history, {})
    vim.keymap.set("n", "<leader>sj", builtin.jumplist, {})
    vim.keymap.set("n", "<leader>p", builtin.registers, {})
    vim.keymap.set("n", "<leader>P", builtin.pickers, {})

    -- vim.keymap.set("n", "<leader>sb", builtin.current_buffer_fuzzy_find, {})
    vim.keymap.set("n", "<leader>sb", function()
      builtin.current_buffer_fuzzy_find({ 
        sorter = require('telescope.sorters').get_substr_matcher({})});
    end )
    vim.keymap.set("n", "<leader>sg", function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end)

  end
}

