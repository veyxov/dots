-- Settings and options
local opt = vim.opt

-- NumberLine
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'number' -- One line for everything

-- Optimizations
opt.wrap = false
opt.showmode = false
opt.swapfile = false
opt.lazyredraw = true

-- Tabs or spaces ?
opt.expandtab = true

local tab_size = 4
opt.tabstop = tab_size
opt.shiftwidth = tab_size
opt.softtabstop = tab_size

-- Nice colors in the terminal
opt.termguicolors = true

-- Pseudo transparent menu popups
opt.pumblend = 20
vim.cmd [[ hi PmenuSel blend=15 ]]

-- Smart searching
opt.smartcase = true
opt.ignorecase = true

-- Experimental
opt.wildignorecase = true
opt.completeopt = {"menu", "menuone", "preview", "noselect", "noinsert"}

-- For opening splits on right or bottom.
opt.splitbelow = true
opt.splitright = true


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
