return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "telekasten" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    file_types = { "markdown", "telekasten" },
    heading = {
      backgrounds = {
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
      },
    },
    render_modes = true,
  },
}
