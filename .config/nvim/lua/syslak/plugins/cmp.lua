return {
  'hrsh7th/nvim-cmp',
  -- event = "InsertEnter",
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    "onsails/lspkind.nvim",

    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
    -- 'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/nvim-cmp',


    -- Adds a number of user-friendly snippets
    -- 'rafamadriz/friendly-snippets',
  },

  config = function()
    local lspkind = require("lspkind")
    lspkind.init {}
    -- local luasnip = require('luasnip')
    -- require('luasnip.loaders.from_vscode').lazy_load()
    -- luasnip.config.setup {}

    local cmp = require('cmp')
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert {
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-u>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
      },
      sources = {
        {
          name = 'lazydev',
          group_index = 0,
        },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        -- { name = 'buffer' },
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol",
          maxwidth = 50,
        })
      }
    }
  end
}
