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
	{ "<leader>bd", function() Snacks.bufdelete() end, desc = "[B]uffer [D]elete"}
  }
}
