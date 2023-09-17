-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim',--, tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use("olimorris/onedarkpro.nvim")
    use("cpea2506/one_monokai.nvim")
    use("loctvl842/monokai-pro.nvim")



    use({
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    })

  -- use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})

    -- use {
    --     'nvim-treesitter/nvim-treesitter',
    --     run = function()
    --         local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
    --         ts_update()
    --     end,
    -- }

    use('mbbill/undotree')
    use('tpope/vim-fugitive')

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }
    use("ThePrimeagen/vim-be-good")

    use("lervag/vimtex")

    use("ixru/nvim-markdown")

    use("JuliaEditorSupport/julia-vim")


end)
