require "telescope".setup {
    defaults = {
        selection_caret = '→ ',
        prompt_prefix = '❯ ',
        winblend = 10,
        borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        preview = {
            timeout = 100,
            filesize_limit = 1,
            treesitter = false,
        },
        layout_strategy = 'bottom_pane',
        layout_config = { height = 0.99 },
    },
    extensions = {
        fzf = {
            case_mode = "smart_case",
        }
    }
}
