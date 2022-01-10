require 'telescope'.setup {
	defaults = {
		prompt_prefix = '→ ',
		selection_caret = '❯ ',
		winblend = 10, -- Pseudo transparency
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
