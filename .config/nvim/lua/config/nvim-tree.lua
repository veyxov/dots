require'nvim-tree'.setup {
    auto_close           = true,
    update_cwd           = false,
    filters = {
        dotfiles = true,
    },
    view = {
        width = 30,
        height = 30,
        hide_root_folder = false,
        side = 'left',
        auto_resize = false,
        mappings = {
            custom_only = false,
            list = {}
        },
        number = false,
        relativenumber = false,
        signcolumn = "yes"
    },
}
