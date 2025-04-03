return {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true },
  config = function()
    local lualine = require('lualine')

    local function is_tmux()
      return os.getenv("TMUX") ~= nil
    end

    -- Now, configure lualine status line
    lualine.setup {
      options = {
        -- Your other options here
        -- You can access the function directly in the statusline
        theme = "gruvbox-material",
        section_separators = '', component_separators = '',
      },
      sections = {
        lualine_c = { 'filename',
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
  end
}
