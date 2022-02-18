local nightfox = require('nightfox')
nightfox.setup({
    alt_nc = true, -- Non current window bg to alt color see `hl-NormalNC`
    inverse = {
        match_paren = true, -- Enable/Disable inverse highlighting for match parens
        visual = true, -- Enable/Disable inverse highlighting for visual selection
        search = true, -- Enable/Disable inverse highlights for search highlights
    },
})

vim.cmd [[
    colorscheme nordfox
]]
