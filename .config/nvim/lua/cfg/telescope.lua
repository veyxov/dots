require "telescope".setup {
    defaults = {
        selection_caret = '\t',
        entry_prefix = '',
        prompt_prefix = '❯ ',
        winblend = 10,
        border = false,
        borderchars = { '', '', '', '', '', '', '', '' },
        preview = {
            timeout = 100,
            filesize_limit = 1,
            treesitter = false,
        },
        layout_strategy = 'center',
    },
    extensions = {
        fzf = {
            case_mode = "smart_case",
        }
    }
}
