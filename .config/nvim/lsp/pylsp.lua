local function pick_cmd()
  local venv = os.getenv('VIRTUAL_ENV')
  if venv then
    return { venv .. '/bin/python', '-m', 'pylsp' }
  end
  local mason_pylsp = vim.fn.stdpath('data') .. '/mason/bin/pylsp'
  if vim.fn.executable(mason_pylsp) == 1 then
    return { mason_pylsp }
  end
  return { 'pylsp' }
end

return {
  cmd = pick_cmd(),
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          enabled = true,
          ignore = { 'W391', 'W503' },
          maxLineLength = 100,
        },
        jedi_completion = { enabled = true },
      },
    },
  },
}
