local opt = vim.opt

-- opt.inccommand = "split"
opt.smartcase = true

opt.number = true
opt.relativenumber = true

opt.signcolumn = "yes"

opt.swapfile = false

opt.undofile = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.scrolloff = 8


opt.virtualedit = "block" -- allow going past end of line in visual block mode
opt.formatoptions = "qjl1" -- Don't autoformat comments
opt.pumblend = 10

