require "material".setup({
    contrast = {
        sidebars = true,
        floating_windows = true,
        line_numbers = false,
        sign_column = false,
        non_current_windows = true,
        popup_menu = true,
    },

    italics = {
        comments = true,
        keywords = false,
        functions = false,
        strings = false,
        variables = false
    },

    contrast_filetypes = { -- Specify which filetypes get the contrasted (darker) background
        "terminal", -- Darker terminal background
        "packer", -- Darker packer background
        "qf" -- Darker qf list background
    },

    disable = {
        borders = false, -- Disable borders between verticaly split windows
        background = false, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
        term_colors = false, -- Prevent the theme from setting terminal colors
        eob_lines = false -- Hide the end-of-buffer lines
    },

    lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )

    async_loading = true -- Load parts of the theme asyncronously for faster startup (turned on by default)
})
