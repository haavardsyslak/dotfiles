function Fargelegg(color)
    color = color or "one_monokai"
    if color == "one_monokai" then
        require(color).setup({
            transparent = true,
            italics = true,
        })
    end

    if color == "dracula" then
        require("dracula").setup({
            italic_comment = true, -- default false
            transparent_bg = true, -- default false
        })
    end

 --    require("monokai-pro").setup({
 --        transparent_background = true,
 --        backgrund_clear = {"telescope", "nvim_tree"},
 --        terminal_colors = true,
 --    })

	vim.cmd.colorscheme(color)
	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end

Fargelegg()
