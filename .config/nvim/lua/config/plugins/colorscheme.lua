return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = true,
    init = function()
      require("gruvbox").setup({
        transparent_mode = false,
        dim_inactive = false,
        inverse = false,
        overrides = {
          NormalFloat = { bg = "#1d2025" },
          RenderMarkdownH1Bg = { bg = "#3c3836" },
          RenderMarkdownH2Bg = { bg = "#3c3836" },
          RenderMarkdownH3Bg = { bg = "#3c3836" },
          RenderMarkdownH4Bg = { bg = "#3c3836" },
          RenderMarkdownH5Bg = { bg = "#3c3836" },
          RenderMarkdownH6Bg = { bg = "#3c3836" },
        }
      })
      vim.cmd.colorscheme("gruvbox")
    end
  },
}
