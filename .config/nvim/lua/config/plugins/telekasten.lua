return {
  'renerocksai/telekasten.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    require('telekasten').setup({
      home = vim.fn.expand("~/vault/"),
      dailies = vim.fn.expand("~/vault/dailies/"),
      weeklies = vim.fn.expand("~/vault/weeklies/"),
      templates = vim.fn.expand("~/vault/templates"),
      follow_creates_nonexisting = true,
      dailies_create_nonexisting = true,
      weeklies_create_nonexisting = true,
    })
    vim.keymap.set("n", "<leader>o", "<cmd>Telekasten panel<CR>")

    -- Most used functions
    vim.keymap.set("n", "<leader>of", "<cmd>Telekasten find_notes<CR>")
    vim.keymap.set("n", "<leader>os", "<cmd>Telekasten search_notes<CR>")
    vim.keymap.set("n", "<leader>od", "<cmd>Telekasten goto_today<CR>")
    vim.keymap.set("n", "<leader>oz", "<cmd>Telekasten follow_link<CR>")
    vim.keymap.set("n", "<leader>on", "<cmd>Telekasten new_note<CR>")
    vim.keymap.set("n", "<leader>oc", "<cmd>Telekasten show_calendar<CR>")
    vim.keymap.set("n", "<leader>ob", "<cmd>Telekasten show_backlinks<CR>")
    vim.keymap.set("n", "<leader>oI", "<cmd>Telekasten insert_img_link<CR>")

    -- Call insert link automatically when we start typing a link
    vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")
  end
}
