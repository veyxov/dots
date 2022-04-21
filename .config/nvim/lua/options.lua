local opt = vim.opt

vim.g.mapleader = " "

opt.swapfile = false

-- Cool floating window popup menu for completion on command line
opt.completeopt = { 'menu', 'menuone' } -- for cmp
opt.pumblend = 20
opt.wildmode = "longest:full"
opt.wildoptions = "pum"
opt.termguicolors = true

opt.showmode = false
opt.updatetime = 250

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

-- Check out invisible characters
opt.listchars = "tab:>·,trail:•,extends:>,precedes:<,space:␣,eol:↴"
