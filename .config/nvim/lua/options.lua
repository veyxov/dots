-- Settings and options
local opt = vim.opt

-- NumberLine
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'number' -- One line for everything

-- Optimizations
opt.lazyredraw = true
opt.wrap = false
opt.showmode = false
opt.swapfile = false

-- Tabs or spaces ?
opt.expandtab = true
opt.cursorline = true

local tab_size = 4
opt.tabstop = tab_size
opt.shiftwidth = tab_size
opt.softtabstop = tab_size

-- Check out invisible characters
opt.listchars = "tab:>·,trail:•,extends:>,precedes:<,space:␣,eol:↴"

-- Nice colors in the terminal
opt.termguicolors = true

-- Pseudo transparent menu popups
opt.pumblend = 20
vim.cmd [[ hi PmenuSel blend=15 ]]

-- Smart searching
opt.ignorecase = true
opt.smartcase = true

-- Experimental
opt.completeopt = {"menu", "menuone", "preview", "noselect", "noinsert"}
opt.wildignorecase = true

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

for _, plugin in pairs(disabled_built_ins) do
        vim.g["loaded_" .. plugin] = 1
end
