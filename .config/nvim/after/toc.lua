local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function vimtex_toc()
  local entries = vim.fn["vimtex#toc#get_entries"]()
  if not entries then
    print("No VimTeX ToC available")
    return
  end

  local results = {}
  for _, entry in ipairs(entries) do
    local line = entry.line
    local title = entry.title
    local lnum = entry.lnum
    table.insert(results, { line = lnum, display = title, value = lnum })
  end

  pickers.new({}, {
    prompt_title = "VimTeX Table of Contents",
    finder = finders.new_table({
      results = results,
      entry_maker = function(entry)
        return {
          value = entry.value,
          display = entry.display,
          ordinal = entry.display,
          lnum = entry.lnum,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      actions.select_default:replace(function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.api.nvim_win_set_cursor(0, { selection.value, 0 })
      end)
      return true
    end,
  }):find()
end

vim.api.nvim_create_user_command("VimtexTocTelescope", vimtex_toc, {})
