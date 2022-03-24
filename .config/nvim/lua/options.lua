local opt = vim.opt

vim.g.mapleader = " "

opt.swapfile = false

-- Cool floating window popup menu for completion on command line
opt.pumblend = 20
opt.wildmode = "longest:full"
opt.wildoptions = "pum"
opt.termguicolors = true

opt.showmode = false
opt.updatetime = 1000

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
-- Disable some builtin vim plugins
local disabled_built_ins = {
    "2html_plugin", "getscript", "getscriptPlugin",
    "gzip", "logipat", "netrw", "netrwPlugin",
    "netrwSettings", "netrwFileHandlers", "matchit",
    "tar", "tarPlugin", "rrhelper", "spellfile_plugin",
    "vimball", "vimballPlugin", "zip", "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do vim.g["loaded_" .. plugin] = 1 end

-- Check out invisible characters
opt.listchars = "tab:>·,trail:•,extends:>,precedes:<,space:␣,eol:↴"
