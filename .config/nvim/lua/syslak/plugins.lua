local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)


local plugins = {
    "cpea2506/one_monokai.nvim",
    "Yazeed1s/oh-lucy.nvim",
    {'nvim-telescope/telescope.nvim',--, tag = '0.1.0',
    -- or                            , branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        },
    },
    {'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate'
    },
    {'neovim/nvim-lspconfig',
        dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',

        -- Useful status updates for LSP
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        -- { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

        -- Additional lua configuration, makes nvim stuff amazing!
        'folke/neodev.nvim',
        },
    },

    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',


            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',
        },
    },

    -- Useful plugin to show you pending keybinds.
    {
        'folke/which-key.nvim', opts = {}
    },


    'mbbill/undotree',


    {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    },
    {
        "lervag/vimtex",
        lazy = false,     -- we don't want to lazy load VimTeX
        -- tag = "v2.15", -- uncomment to pin to a specific release
        init = function()
            vim.g.vimtex_view_method = "zathura"
            -- VimTeX configuration goes here
        end
    },
    "numToStr/Comment.nvim",
   "mfussenegger/nvim-dap",
   {
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
   },
   {
    "epwalsh/obsidian.nvim",
    version = "*"
   },
   'Mofiqul/dracula.nvim',
   {
       "ThePrimeagen/harpoon",
       branch = "harpoon2",
       dependencies = { "nvim-lua/plenary.nvim" }
   },
   "jpalardy/vim-slime",
}

local opts = {}

require("lazy").setup(plugins, opts)


