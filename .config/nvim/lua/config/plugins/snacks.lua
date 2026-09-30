return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    -- scope = { enabled = true },
    -- words = { enabled = true },
    bufdelete = { enabled = true },
  },
  keys = {
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "[B]uffer [D]elete" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "[D]iff hunks (uncommitted)" },
    {
      "<leader>gm",
      function()
        local base = require("config.git").default_branch()
        if base then Snacks.picker.git_diff({ base = base }) end
      end,
      desc = "Diff hunks vs [M]ain",
    },
  },
}
