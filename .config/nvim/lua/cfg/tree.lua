require("nvim-tree").setup {
    auto_close = true,
    hijack_cursor = true,
    open_on_setup = true,
    diagnostics = {
        enable = true,
        show_on_dirs = true,
    },
    filters = {
        dotfiles = true,
    },
    git = {
        enable = true,
        ignore = false,
        timeout = 400,
    },
}
