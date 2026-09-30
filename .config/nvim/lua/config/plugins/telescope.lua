return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    -- "nvim-telescope/telescope-smart-history.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    -- "kkharji/sqlite.lua",
  },
  config = function()
    require("telescope").setup({
      extensions = {
        fzf = {},
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {},
        },
      },
    })

    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
    local builtin = require('telescope.builtin')
    vim.keymap.set("n", "<leader>.", builtin.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>,", function()
      if not pcall(builtin.git_files) then
        builtin.find_files()
      end
    end, { desc = "Git files" })
    -- vim.keymap.set("n", "<leader>," builtin.oldfiles, {})
    vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>sd", builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set("n", "<leader>sc", builtin.command_history, { desc = "Command history" })
    vim.keymap.set("n", "<leader>sj", builtin.jumplist, { desc = "Jumplist" })
    vim.keymap.set("n", "<leader>p", builtin.registers, { desc = "Registers" })
    vim.keymap.set("n", "<leader>P", builtin.pickers, { desc = "Previous pickers" })

    vim.keymap.set("n", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "Search buffer" })
    vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Grep word" })
    vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help tags" })
    vim.keymap.set("n", "<leader>sm", builtin.man_pages, { desc = "Man pages" })
    vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume picker" })
    vim.keymap.set("n", "<leader>st", builtin.treesitter, { desc = "Treesitter symbols" })
    vim.keymap.set("n", "<leader>sB", builtin.builtin, { desc = "All pickers" })

    vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
    vim.keymap.set("n", "<leader>so", builtin.oldfiles, { desc = "Recent files" })
    vim.keymap.set("n", "<leader>gc", builtin.git_bcommits, { desc = "Buffer commits" })
  end
}
