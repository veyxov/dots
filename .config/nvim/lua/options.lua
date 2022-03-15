local o = vim.o

o.termguicolors = true

-- o.number = true
-- o.relativenumber = true

o.ignorecase = true
o.smartcase = true
o.expandtab = true

o.signcolumn = 'number' -- One line for everything

--o.completeopt = { "menu", "menuone", "noselect" }

-- oimizations
o.wrap = false
o.showmode = false
o.swapfile = false
o.lazyredraw = true

-- Tabs or spaces ?
o.expandtab = true
local tab_size = 4
o.tabstop = tab_size
o.shiftwidth = tab_size
o.softtabstop = tab_size

-- Pseudo transparent menu popups
o.pumblend = 20
vim.cmd [[ hi PmenuSel blend=15 ]]

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
o.listchars = "tab:>·,trail:•,extends:>,precedes:<,space:␣,eol:↴"
