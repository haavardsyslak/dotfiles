return {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          enabled = true,
          ignore = { 'W391', 'W503' },
          maxLineLength = 100
        },
        jedi_completion = {
          enabled = true,
        },
      },
    },
  },
}
