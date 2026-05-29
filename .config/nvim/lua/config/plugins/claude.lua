local function ask_claude(context_cmd)
  vim.ui.input({ prompt = "Ask Claude: " }, function(input)
    if not input or input == "" then return end
    vim.cmd(context_cmd)
    vim.cmd("ClaudeCodeFocus")
    vim.defer_fn(function()
      local buf = vim.api.nvim_get_current_buf()
      local chan = vim.b[buf].terminal_job_id
      if chan then
        vim.api.nvim_chan_send(chan, input .. "\n")
      end
    end, 100)
  end)
end

return {
  "coder/claudecode.nvim",
  enabled = false,
  -- dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal = {
      provider = "native",
      split_side = "right",
      split_width_percentage = 0.35,
    },
  },
  keys = {
    { "<leader>a.", "<cmd>ClaudeCodeFocus<cr>", mode = { "n", "t" }, desc = "Toggle Claude" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", mode = "n",          desc = "Add buffer to Claude" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>",  mode = "x",          desc = "Send selection to Claude" },
    {
      "<leader>aq",
      function() ask_claude("ClaudeCodeSend") end,
      mode = "x",
      desc = "Ask Claude about selection",
    },
    {
      "<leader>aq",
      function() ask_claude("ClaudeCodeAdd " .. vim.api.nvim_buf_get_name(0)) end,
      mode = "n",
      desc = "Ask Claude about buffer",
    },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", mode = "n", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   mode = "n", desc = "Deny diff" },
  },
}
