    return {
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
    }
