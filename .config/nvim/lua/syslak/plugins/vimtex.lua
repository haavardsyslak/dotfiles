return {
  "lervag/vimtex",
  lazy = false,     -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_matchparen_enabled = false
    vim.g.vimtex_compiler_latexmk = {
        out_dir = "build",
        aux_dir = "build",
    }

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
  print("ASDFSDF")
  print(entries)
  for _, entry in ipairs(entries) do
    local section_num = entry.numbered or ""  -- Get section number if available
    local title = entry.title
    local lnum = entry.lnum
    local display = (section_num ~= "" and section_num .. " " or "") .. title  -- Format display text

    table.insert(results, { line = lnum, display = display, value = lnum })
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
end
}
