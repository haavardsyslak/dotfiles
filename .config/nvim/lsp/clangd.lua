return {
  cmd = { 'clangd', '--background-index' },
  init_options = {
    clangdFileStatus = true,
    usePlaceholders = true,
    completeUnimported = true,
  },
}

