require "nvim-treesitter.configs".setup {
	highlight = {
		enable = true,

		-- list of language that will be disabled
		disable = { },

		additional_vim_regex_highlighting = false,
	},

	indent = {
		enable = true,
		disable = { },
	}
}
