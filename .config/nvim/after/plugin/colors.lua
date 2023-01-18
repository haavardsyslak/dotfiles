function Fargelegg(color)
	color = color or "one_monokai"
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end
-- italics seem to be working

Fargelegg()
