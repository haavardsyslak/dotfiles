local M = {}

function M.run_cpplint(command)
  -- TODO: check that the arg to cpp lint is a file
  -- TODO: check what happens when we rur cppplint on non cpp / hpp files
  -- local command = 'find src -type f -name "*.*pp" | xargs cpplint'
  local output = {}
  print(command)
  vim.fn.jobstart(command, {
    stdout_buffered = true,
    stderr_buffered = true,

    on_stdout = function(_, data, _)
      if data then
        vim.list_extend(output, data)
      end
    end,
    on_stderr = function(_, data, _)
      if data then
        vim.list_extend(output, data)
      end
    end,
    on_exit = function(_, exit_code, _)
      vim.schedule(function()
        local qf_list = M.parse_cpplint_output(output)
        if #qf_list > 0 then
          vim.fn.setqflist({}, "r", { title = "cpplint", items = qf_list })
          vim.cmd("copen")
        elseif exit_code ~= 0 then
          local output_text = table.concat(output, "\n")
          vim.notify("Cpplint faield with exit code " .. exit_code .. output_text)
        else
          vim.notify("Cpplint reported no errors", vim.log.levels.INFO)
        end
      end)
    end
  })
end

--   local output = vim.fn.systemlist(command)
--   local qf_list = {}
--
--   for _, line in ipairs(output) do
--     local filename, lnum, msg = string.match(line, "^(.+):(%d+):%s+(.*)$")
--     if filename and lnum then
--       table.insert(qf_list, { filename = filename, lnum = tonumber(lnum), col = 1, text = msg })
--     end
--     vim.fn.setqflist({}, "r", { title = "cpp-lint", items = qf_list })
--     vim.cmd("copen")
--   end
-- end

function M.parse_cpplint_output(output)
  local results = {}
  for _, line in ipairs(output) do
    local filename, lnum, msg = string.match(line, "^(.+):(%d+):%s+(.*)$")
    if filename and lnum then
      table.insert(results, { filename = filename, lnum = tonumber(lnum), col = 1, text = msg })
    end
  end
  return results
end

local function get_find_cmd()
  local fd_args = "-e cpp -e hpp"
  if vim.fn.executable("fd") == 1 then
    return "fd " .. fd_args
  elseif vim.fn.executable("fdfind") == 1 then
    return "fdfind " .. fd_args
  else
    return 'find src -type f -name "*.*pp"'
  end
end

vim.api.nvim_create_user_command("CppLintProject", function()
  M.run_cpplint(get_find_cmd() .. " | xargs cpplint")
end, {})

vim.api.nvim_create_user_command("CppLintBuf", function()
  M.run_cpplint("cpplint" .. vim.fn.expand("%"))
end, {})

return M
