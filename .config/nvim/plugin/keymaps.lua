local set = vim.keymap.set

-- Navigation
set("n", "<Leader>wl", "<C-w>l")
set("n", "<Leader>wh", "<C-w>h")
set("n", "<Leader>wj", "<C-w>j")
set("n", "<Leader>wk", "<C-w>k")
set("n", "<Leader>w=", "<C-w>=")


-- close and split
set("n", "<Leader>wd", ":close<CR>")
set("n", "<Leader>wv", ":vsplit ")
set("n", "<Leader>ws", ":split ")

 -- Quicker window resize
vim.keymap.set("n", "<C-A-h>", "<C-w><")
vim.keymap.set("n", "<C-A-l>", "<C-w>>")
vim.keymap.set("n", "<C-A-k>", "<C-w>-")
vim.keymap.set("n", "<C-A-j>", "<C-w>+")

-- Clear searches with æ
vim.keymap.set("n", "æ", ":noh<return>")

-- Smart Ctrl-Enter: continue comment / list item on new line (like org-mode meta-return)
local function smart_continue()
  if vim.bo.filetype == "org" then
    local ok, orgmode = pcall(require, "orgmode")
    if ok then
      orgmode.action("org_mappings.meta_return")
      return
    end
  end

  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)

  -- comment continuation, via 'commentstring'
  local cs = vim.bo.commentstring
  if cs and cs:find("%%s") then
    local prefix = vim.trim(cs:match("^(.-)%%s"))
    if prefix ~= "" then
      local indent, lead = line:match("^(%s*)(" .. vim.pesc(prefix) .. "%s*)")
      if indent then
        local rest = line:sub(#indent + #lead + 1)
        if vim.trim(rest) ~= "" then
          vim.api.nvim_buf_set_lines(0, row, row, false, { indent .. lead })
          vim.api.nvim_win_set_cursor(0, { row + 1, #(indent .. lead) })
          return
        end
      end
    end
  end

  -- list continuation: checkbox, bullet, numbered
  local patterns = {
    "^(%s*[%-%*%+]%s+%[[ xX%-]?%]%s+)",
    "^(%s*[%-%*%+]%s+)",
    "^(%s*%d+[%.%)]%s+)",
  }
  for _, pat in ipairs(patterns) do
    local marker = line:match(pat)
    if marker then
      local rest = line:sub(#marker + 1)
      if vim.trim(rest) == "" then
        -- empty item: drop marker and exit list
        local indent = line:match("^%s*") or ""
        vim.api.nvim_set_current_line(indent)
        vim.api.nvim_win_set_cursor(0, { row, #indent })
        return
      end
      local indent, num, closer = marker:match("^(%s*)(%d+)([%.%)])%s+")
      local newmarker
      if num then
        newmarker = indent .. tostring(tonumber(num) + 1) .. closer .. " "
      else
        newmarker = (marker:gsub("%[[ xX%-]?%]", "[ ]"))
      end
      vim.api.nvim_buf_set_lines(0, row, row, false, { newmarker })
      vim.api.nvim_win_set_cursor(0, { row + 1, #newmarker })
      return
    end
  end

  vim.api.nvim_feedkeys(cr, "n", true)
end

vim.keymap.set("i", "<C-CR>", smart_continue, { desc = "Continue comment/list item on new line" })


