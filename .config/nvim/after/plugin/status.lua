local lualine = require('lualine')

local function is_tmux()
  return os.getenv("TMUX") ~= nil
end

-- Now, configure lualine status line
lualine.setup {
  options = {
    -- Your other options here
    -- You can access the function directly in the statusline
    section_separators = '', component_separators = '',
  },
  sections = {
    lualine_c = {'filename',
      {
        function() 
          if is_tmux() then
            return '' 
          else
            return ''
          end
        end,
        color = { fg = '#6BBF59' },
        style = 'bold',
      }
    }
  }
}

-- require('lualine').setup({
--     options = {
--         icons_enabled = false,
--     component_separators = { left = '', right = ''},
--     section_separators = { left = '', right = ''},
--     }
-- })
