require('mason').setup()

local config_dir = vim.fn.stdpath("config") .. "/lsp"
local files = vim.fn.globpath(config_dir, "*.lua", false, true)

local servers = {}
local clangd_config = nil  -- captured for dynamic cmd setup below

for _, filepath in ipairs(files) do
  local name = vim.fn.fnamemodify(filepath, ":t:r")

  -- Get default config from lspconfig
  local lspconfig_ok, lspconfig_defaults = pcall(function()
    return require('lspconfig.configs')[name] or require('lspconfig.server_configurations.' .. name)
  end)

  local base_config = {}
  if lspconfig_ok and lspconfig_defaults and lspconfig_defaults.default_config then
    base_config = vim.deepcopy(lspconfig_defaults.default_config)
  end

  -- Load user overrides from lsp/*.lua files
  local ok, user_config = pcall(function()
    return dofile(filepath)
  end)

  if ok and user_config then
    base_config = vim.tbl_deep_extend('force', base_config, user_config)
  end

  -- Special handling for pylsp to use virtual environment or Mason installation
  if name == 'pylsp' then
    local venv = os.getenv('VIRTUAL_ENV')
    if venv then
      -- If in a virtual environment, use that Python's pylsp
      base_config.cmd = { venv .. '/bin/python', '-m', 'pylsp' }
    else
      -- Otherwise use Mason's pylsp installation
      local mason_pylsp = vim.fn.stdpath('data') .. '/mason/bin/pylsp'
      if vim.fn.executable(mason_pylsp) == 1 then
        base_config.cmd = { mason_pylsp }
      end
    end
    vim.lsp.config(name, base_config)
    table.insert(servers, name)
  elseif name == 'clangd' then
    -- cmd is chosen dynamically per project root; handled below
    clangd_config = base_config
  else
    -- Use new Neovim 0.11+ API to avoid deprecation warning
    vim.lsp.config(name, base_config)
    table.insert(servers, name)
  end
end

-- Enable all auto-configured servers
vim.lsp.enable(servers)

-- clangd: select host or docker clangd based on project root
if clangd_config then
  local source_dir = vim.fn.expand('$HOME') .. '/source'

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
    callback = function(ev)
      local root = vim.fs.root(ev.buf, { 'compile_commands.json', '.clangd', 'CMakeLists.txt', '.git' })
      if not root then return end

      local cmd
      if root:sub(1, #source_dir) == source_dir then
        local running = vim.fn.system('docker ps --filter name=blunux-devcontainer --format {{.Names}}')
        if running:match('blunux%-devcontainer') then
          cmd = {
            'docker', 'exec', '-i', 'blunux-devcontainer',
            'clangd', '--background-index',
            '--path-mappings=' .. source_dir .. '=/workspaces/source',
          }
        else
          vim.notify('[lsp] blunux-devcontainer not running, falling back to host clangd', vim.log.levels.WARN)
          cmd = clangd_config.cmd
        end
      else
        cmd = clangd_config.cmd
      end

      vim.lsp.start(vim.tbl_deep_extend('force', clangd_config, {
        name = 'clangd',
        cmd = cmd,
        root_dir = root,
      }))
    end,
  })
end

-- Copilot toggle keybind (global, not buffer-specific)
vim.keymap.set('n', '<leader>tc', function()
  require('copilot.command').toggle()
end, { noremap = true, silent = true, desc = '[T]oggle [C]opilot' })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local buf = ev.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
    end

    map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    map("n", "<leader>cf", vim.lsp.buf.format, "[C]ode [F]ormat")

    local builtin = require("telescope.builtin")
    map("n", "gd", builtin.lsp_definitions, "[G]oto [D]efinition")
    map("n", "gR", builtin.lsp_references, "[G]oto [R]eferences")
    map("n", "gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
    map("n", "<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
    map("n", "<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
    map("n", "<leader>ss", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
    map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    map("n", "<leader>wf", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    -- Diagnostics
    map('n', 'gl', vim.diagnostic.open_float, 'Floating diagnostics message')
    map('n', ']d', vim.diagnostic.goto_next, 'Goto next diagnostics message')
    map('n', '[d', vim.diagnostic.goto_prev, 'Goto prev diagnostics message')
  end,
})
