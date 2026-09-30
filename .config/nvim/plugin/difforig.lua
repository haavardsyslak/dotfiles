-- :DiffOrig — diff the buffer against the file on disk.
-- For when the buffer and the file both changed (e.g. an LLM wrote to it).
-- In your buffer: ]c [c to jump, `do` to take the disk hunk. Then q the disk
-- window and :w! (the file on disk is newer than the buffer).

local function diff_orig()
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(buf)
  if path == "" or vim.fn.filereadable(path) == 0 then
    vim.notify("DiffOrig: no file on disk for this buffer", vim.log.levels.WARN)
    return
  end
  local ft = vim.bo[buf].filetype
  local win = vim.api.nvim_get_current_win()

  vim.cmd("vertical new")
  local scratch = vim.api.nvim_get_current_buf()
  vim.bo[scratch].buftype = "nofile"
  vim.bo[scratch].bufhidden = "wipe"
  vim.bo[scratch].swapfile = false
  vim.api.nvim_buf_set_lines(scratch, 0, -1, false, vim.fn.readfile(path))
  vim.bo[scratch].modifiable = false
  vim.bo[scratch].filetype = ft
  pcall(vim.api.nvim_buf_set_name, scratch, "disk://" .. path)
  vim.cmd("diffthis")
  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = scratch, desc = "Close DiffOrig" })

  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = scratch,
    once = true,
    callback = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_call(win, function() vim.cmd("diffoff") end)
      end
    end,
  })

  vim.api.nvim_set_current_win(win)
  vim.cmd("diffthis")
end

vim.api.nvim_create_user_command("DiffOrig", diff_orig, { desc = "Diff buffer against file on disk" })
vim.keymap.set("n", "<leader>do", diff_orig, { desc = "[D]iff against [O]n-disk file" })
