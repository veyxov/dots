require("harpoon").setup({
    -- closes any tmux windows harpoon that harpoon creates when you close Neovim.
    tmux_autoclose_windows = true,
    -- filetypes that you want to prevent from adding to the harpoon list menu.
    excluded_filetypes = { "harpoon" },

    -- set marks specific to each git branch inside git repository
    mark_branch = false,
    -- Dynamic size
    menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
    }
})
