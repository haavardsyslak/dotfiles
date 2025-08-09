    return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
        init = function()
            require("gruvbox").setup({
                transparent_mode = true,
                dim_inactive = false,
				overrides = {
					NormalFloat = {bg = "#1d2025" },
				}
            })
            vim.cmd.colorscheme("gruvbox")
        end
    },
    }
