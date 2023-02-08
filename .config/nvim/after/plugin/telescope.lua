local builtin = require('telescope.builtin')
vim.keymap.set("n", "<leader>.", builtin.find_files, {})
vim.keymap.set("n", "<leader><leader>", builtin.buffers, {})
vim.keymap.set("n", "<leader>sd", builtin.live_grep, {})
-- vim.keymap.set("n", "<leader>sb", builtin.current_buffer_fuzzy_find, {})
vim.keymap.set("n", "<leader>sb", function()
    builtin.current_buffer_fuzzy_find({ sorter = require('telescope.sorters').get_substr_matcher({})});
    end )
vim.keymap.set("n", "<leader>sg", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

