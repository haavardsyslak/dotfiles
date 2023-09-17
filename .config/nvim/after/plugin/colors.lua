function Fargelegg(color)
    -- color = color or "one_monokai"
    color = color or "monokai-pro"
    require("monokai-pro").setup({
        transparent_background = true,
        backgrund_clear = {"telescope", "nvim_tree"},
        terminal_colors = true,

    })

	vim.cmd.colorscheme(color)
	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end
-- italics seem to be working

Fargelegg()
