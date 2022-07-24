local saga = require 'lspsaga'

saga.init_lsp_saga({
    saga_winblend = 10,
    code_action_icon = "💡",
    -- show outline
    show_outline = {
        win_position = 'right',
        -- set the special filetype in there which in left like nvimtree neotree defx
        left_with = '',
        win_width = 30,
        auto_enter = true,
        auto_preview = true,
        virt_text = '┃',
        jump_key = 'o',
        -- auto refresh when change buffer
        auto_refresh = true,
    },
    code_action_lightbulb = {
        enable = true,
        sign = true,
        sign_priority = 20,
        virtual_text = false,
    },
})
