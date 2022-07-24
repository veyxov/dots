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
        }
    },
    extensions = {
        fzf = {
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        }
    }
}
