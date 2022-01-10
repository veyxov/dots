require 'bufferline'.setup {
    options = {
        tab_size = 20,
        max_name_length = 20,
        max_prefix_length = 15,
        show_close_icon = false,
        diagnostics = 'nvim_lsp',
        separator_style = 'thin',
        always_show_bufferline = false,
        show_buffer_close_icons = false,
    }
}
