require('mason').setup()

-- Enable every server that has a config file in lsp/*.lua.
-- clangd is excluded because it needs per-project dynamic cmd dispatch below.
local config_dir = vim.fn.stdpath('config') .. '/lsp'
local servers = {}
for _, filepath in ipairs(vim.fn.globpath(config_dir, '*.lua', false, true)) do
  local name = vim.fn.fnamemodify(filepath, ':t:r')
  if name ~= 'clangd' then
    table.insert(servers, name)
  end
end
vim.lsp.enable(servers)

-- clangd: choose host vs docker clangd per project root
local clangd_defaults = dofile(config_dir .. '/clangd.lua')
local source_dir = vim.fn.expand('$HOME') .. '/source'

local function clangd_cmd(root)
  if root:sub(1, #source_dir) ~= source_dir then
    return clangd_defaults.cmd
  end
  local running = vim.fn.system(
    'docker ps --filter name=blunux-devcontainer --format {{.Names}}')
  if not running:match('blunux%-devcontainer') then
    vim.notify('[lsp] blunux-devcontainer not running, using host clangd',
      vim.log.levels.WARN)
    return clangd_defaults.cmd
  end
  return {
    'docker', 'exec', '-i', 'blunux-devcontainer',
    'clangd', '--background-index',
    '--path-mappings=' .. source_dir .. '=/workspaces/source',
  }
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
  callback = function(ev)
    local root = vim.fs.root(ev.buf,
      { 'compile_commands.json', '.clangd', 'CMakeLists.txt', '.git' })
    if not root then return end
    vim.lsp.start(vim.tbl_extend('force', clangd_defaults, {
      name = 'clangd',
      cmd = clangd_cmd(root),
      root_dir = root,
    }))
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local buf = ev.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
    end
    local builtin = require('telescope.builtin')

    map('n', '<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('n', '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    map('n', '<leader>cf', vim.lsp.buf.format, '[C]ode [F]ormat')
    map('n', 'gd', builtin.lsp_definitions, '[G]oto [D]efinition')
    map('n', 'gR', builtin.lsp_references, '[G]oto [R]eferences')
    map('n', 'gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
    map('n', '<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
    map('n', '<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
    map('n', '<leader>ss', builtin.lsp_dynamic_workspace_symbols,
      '[W]orkspace [S]ymbols')
    map('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')
    map('n', '<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
    map('n', 'gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder,
      '[W]orkspace [A]dd Folder')
    map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder,
      '[W]orkspace [R]emove Folder')
    map('n', '<leader>wf', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    map('n', 'gl', vim.diagnostic.open_float, 'Floating diagnostics message')
    map('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end,
      'Next diagnostic')
    map('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end,
      'Prev diagnostic')
  end,
})
