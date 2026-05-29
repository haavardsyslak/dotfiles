return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    highlight = {
      pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
      comments_only = false,
    },
    search = {
      pattern = [[\b(KEYWORDS)(\([^)]*\))?:]],
    },
  },
}
