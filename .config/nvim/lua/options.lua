local opt = vim.opt

vim.g.mapleader = " "

-- Cool floating window popup menu for completion on command line
opt.pumblend = 20
opt.wildmode = "longest:full"
opt.wildoptions = "pum"
opt.termguicolors = true

opt.showmode = false

-- Searching
opt.ignorecase = true
opt.smartcase = true

opt.wrap = false

-- Tab or space ?
local tab = 4
opt.tabstop = tab
opt.shiftwidth = tab
opt.softtabstop = tab
opt.expandtab = true

opt.formatoptions = "rnj"
