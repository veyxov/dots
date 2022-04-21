local true_zen = require("true-zen")

true_zen.setup({
    ui = {
        bottom = {
            laststatus = 0,
            ruler = false,
            showmode = false,
            showcmd = false,
            cmdheight = 1,
        },
        top = {
            showtabline = 0,
        },
        left = {
            number = false,
            relativenumber = false,
            signcolumn = "no",
        },
    },
    modes = {
        ataraxis = {
            left_padding = 32,
            right_padding = 32,
            top_padding = 1,
            bottom_padding = 1,
            ideal_writing_area_width = {0},
            auto_padding = true,
            keep_default_fold_fillchars = true,
            custom_bg = {"none", ""},
            bg_configuration = true,
            quit = "untoggle",
            ignore_floating_windows = true,
            affected_higroups = {
                NonText = true,
                FoldColumn = true,
                ColorColumn = true,
                VertSplit = true,
                StatusLine = true,
                StatusLineNC = true,
                SignColumn = true,
            },
        },
        focus = {
            margin_of_error = 5,
            focus_method = "experimental"
        },
    },
    integrations = {
        tmux = true,
        twilight = true,
        lualine = true,
    }
})
