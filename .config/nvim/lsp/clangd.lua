-- cmd is not set here; it is chosen dynamically in lua/config/lsp.lua based on
-- the project root: projects under $HOME/source use clangd inside the
-- blunux-devcontainer, all other projects use host clangd.
return {
  cmd = { 'clangd', '--background-index' },
  init_options = {
    clangdFileStatus = true,
    usePlaceholders = true,
    completeUnimported = true,
  },
}

