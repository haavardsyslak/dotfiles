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

-- clangd: dispatch to a project-local devcontainer if one exists & is running,
-- otherwise fall back to host clangd.
local clangd_defaults = dofile(config_dir .. '/clangd.lua')

local function strip_jsonc(s)
  s = s:gsub('/%*.-%*/', '')
  s = s:gsub('//[^\n]*', '')
  return s
end

-- Collect every .devcontainer/devcontainer.json from root up through its
-- ancestors (closest first), not just the nearest one. A project can be
-- nested under a parent dir with its own devcontainer (e.g. this repo's own
-- .devcontainer/devcontainer.json vs. the one actually running the container
-- one level up), and the nearest file isn't always the right one.
local function read_devcontainers(root)
  local found = vim.fs.find('.devcontainer/devcontainer.json',
    { upward = true, path = root, type = 'file', limit = math.huge })
  local out = {}
  for _, path in ipairs(found) do
    local f = io.open(path, 'r')
    if f then
      local content = f:read('*a')
      f:close()
      local ok, cfg = pcall(vim.json.decode, strip_jsonc(content))
      if ok then
        table.insert(out, { cfg = cfg, path = path })
      end
    end
  end
  return out
end

local function devcontainer_name(cfg)
  local args = cfg.runArgs or {}
  for i, arg in ipairs(args) do
    local n = arg:match('^%-%-name=(.+)$')
    if n then return n end
    if arg == '--name' and args[i + 1] then return args[i + 1] end
  end
  return nil
end

local function devcontainer_workspace(cfg, host_ws)
  if cfg.workspaceFolder then return cfg.workspaceFolder end
  if cfg.workspaceMount then
    local target = cfg.workspaceMount:match('target=([^,]+)')
    if target then return target end
  end
  return '/workspaces/' .. vim.fs.basename(host_ws)
end

local function container_running(name)
  local out = vim.fn.system(
    string.format('docker ps --filter name=^%s$ --format {{.Names}}', name))
  return out:match('^' .. vim.pesc(name)) ~= nil
end

local function clangd_cmd(root)
  local candidates = read_devcontainers(root)
  -- Prefer the ancestor config whose container is actually running; the
  -- closest devcontainer.json may just be a VS Code image config that was
  -- never started, shadowing the parent dir's config that is.
  for _, c in ipairs(candidates) do
    local cname = devcontainer_name(c.cfg)
    if cname and container_running(cname) then
      local host_ws = vim.fs.dirname(vim.fs.dirname(c.path))
      local container_ws = devcontainer_workspace(c.cfg, host_ws)
      -- root may be nested under host_ws (e.g. host_ws=.../source,
      -- root=.../source/libblunux); map that same relative path into the
      -- container to find this project's own build/compile_commands.json.
      local container_root = container_ws .. root:sub(#host_ws + 1)
      return {
        'docker', 'exec', '-i', cname,
        'clangd', '--background-index',
        '--path-mappings=' .. host_ws .. '=' .. container_ws,
        '--compile-commands-dir=' .. container_root .. '/build',
      }
    end
  end
  if #candidates > 0 then
    vim.notify('[lsp] no running devcontainer found under ' .. root .. ', using host clangd',
      vim.log.levels.WARN)
  end
  local cmd = vim.deepcopy(clangd_defaults.cmd)
  table.insert(cmd, '--compile-commands-dir=' .. root .. '/build')
  return cmd
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
