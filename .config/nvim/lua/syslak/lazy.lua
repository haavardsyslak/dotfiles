-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Setup lazy.nvim
require("lazy").setup({
    change_detection = {
        notify = false,
    },
    { import = "syslak.plugins" },
    -- {
    --     "cpea2506/one_monokai.nvim",
    --     priority = 1000,
    --     opts = {
    --         italic = true,
    --         transparent = true,
    --     },
    --     -- init = function()
    --     --     require("one_monokai").setup({
    --     --         italic = true,
    --     --         transparent = true,
    --     --     })
    --         -- vim.cmd.colorscheme("one_monokai")
    --     -- end
    -- },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
        init = function()
            require("gruvbox").setup({
                transparent_mode = true,
                dim_inactive = false,
            })
            vim.cmd.colorscheme("gruvbox")
        end
    },
    {
        "epwalsh/pomo.nvim",
        version = "*",                 -- Recommended, use latest release instead of latest commit
        lazy = true,
        cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
        dependencies = {
            -- Optional, but highly recommended if you want to use the "Default" timer
            "rcarriga/nvim-notify",
        },
        opts = {
            notifiers = {
                -- The "Default" notifier uses 'vim.notify' and works best when you have 'nvim-notify' installed.
                {
                    name = "Default",
                    opts = {
                        -- With 'nvim-notify', when 'sticky = true' you'll have a live timer pop-up
                        -- continuously displayed. If you only want a pop-up notification when the timer starts
                        -- and finishes, set this to false.
                        sticky = false,

                        -- Configure the display icons:
                        title_icon = "󱎫",
                        text_icon = "󰄉",
                        -- Replace the above with these if you don't have a patched font:
                        -- title_icon = "⏳",
                        -- text_icon = "⏱️",
                    },
                },

                -- The "System" notifier sends a system notification when the timer is finished.
                -- Available on MacOS and Windows natively and on Linux via the `libnotify-bin` package.
                { name = "System" },

                -- You can also define custom notifiers by providing an "init" function instead of a name.
                -- See "Defining custom notifiers" below for an example 👇
                -- { init = function(timer) ... end }
            },
        }
    },
    -- {
    --     'comfysage/evergarden',
    --     priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
    --     opts = {
    --         transparent_background = true,
    --         variant = 'medium', -- 'hard'|'medium'|'soft'
    --         overrides = {}, -- add custom overrides
    --     }
    -- },
    -- { 'Yazeed1s/minimal.nvim', minimal_transparent_background = true},
    -- { "Mofiqul/dracula.nvim", transparent_bg = true },
    -- { "catppuccin/nvim",        name = "catppuccin", priority = 1000, transparent_background = true },
    -- { "rose-pine/neovim",       name = "rose-pine" },
    -- {
    --     "olimorris/onedarkpro.nvim",
    --     priority = 1000, -- Ensure it loads first
    --     opts = {
    --         options = {
    --             transparency = true,
    --             terminal_colors = false,
    --         },
    --     },
    -- },
    -- { 'echasnovski/mini.nvim', version = false },
    --
    -- {
    --     "jghauser/papis.nvim",
    --     dependencies = {
    --         "kkharji/sqlite.lua",
    --         "MunifTanjim/nui.nvim",
    --         "pysan3/pathlib.nvim",
    --         "nvim-neotest/nvim-nio",
    --         -- if not already installed, you may also want:
    --         -- "nvim-telescope/telescope.nvim",
    --         -- "hrsh7th/nvim-cmp",
    --
    --     },
    --     config = function()
    --         require("papis").setup({
    --             -- Your configuration goes here
    --         })
    --     end,
    -- },
    {
        'folke/which-key.nvim',
        enter = "VimEnter",
        opts = {
            spec = {
                { '<leader>c', group = '[C]ode',     mode = { 'n', 'x' } },
                { '<leader>d', group = '[D]ocument' },
                { '<leader>r', group = '[R]ename' },
                { '<leader>s', group = '[S]earch' },
                { '<leader>w', group = '[W]orkspace' },
            },
        }

    },
    -- "numToStr/Comment.nvim",
    "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
    {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = 'luvit-meta/library', words = { 'vim%.uv' } },
            },
        },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    -- install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = false },
})
