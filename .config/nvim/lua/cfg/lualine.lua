require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {},
        always_divide_middle = true,
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {
            {
                'filetype',
                icon_only = true
            }
        },
        lualine_c = {
            {
                'filename',
                path = 1,
                shorting_target = 0
            }
        },
        lualine_x = {'tabs'},
        lualine_y = {'branch', 'diff', 'diagnostics'},
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = { },
    extensions = {
        'nvim-tree',
        'quickfix',
    }
}
