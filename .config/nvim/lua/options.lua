local opt = vim.opt

vim.g.mapleader = " "

opt.swapfile = false

vim.o.completeopt = "menu,menuone,noselect"

-- Visuals
opt.wrap = false
opt.cmdheight = 0
opt.pumblend = 20
opt.laststatus = 0
opt.termguicolors = true

opt.updatetime = 250

-- Searching
opt.ignorecase = true
opt.smartcase  = true

-- Tab or space ?
local tab = 4
opt.tabstop     = tab
opt.shiftwidth  = tab
opt.softtabstop = tab
opt.expandtab   = true
