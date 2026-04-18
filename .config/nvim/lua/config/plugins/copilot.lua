return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = false,      -- disable ghost text UI
        auto_trigger = false, -- do not auto spam suggestions
      },
      panel = { enabled = false },
    },
    keys = {
      { "<leader>tc", function() require('copilot.command').toggle() end,
        desc = "[T]oggle [C]opilot" },
    },
  },

  {
    "fang2hou/blink-copilot",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "saghen/blink.cmp",
    },

    opts = {
      max_completions = 3,
      debounce = 200,
    },
  },
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "copilot" },

        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            async = true,

            -- optional tuning:
            score_offset = -5, -- lower priority than LSP
          },
        },
      },
    },
    opts_extend = { "sources.default" },
  },

}
