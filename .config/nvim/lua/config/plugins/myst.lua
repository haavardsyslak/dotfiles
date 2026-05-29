return {
  'QuantEcon/myst-markdown-tree-sitter.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ft = { "markdown", "myst" },
  config = function()
    require('myst-markdown').setup()
  end,
}
