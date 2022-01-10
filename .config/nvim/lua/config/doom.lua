require('doom-one').setup({
	cursor_coloring = true,
	italic_comments = true,
	terminal_colors = true,
	enable_treesitter = true,
	transparent_background = true,
	pumblend = {
		enable = true,
		transparency_amount = 20,
	},
	plugins_integrations = {
		neogit = true,
		lspsaga = true,
		telescope = true,
		bufferline = true,
		indent_blankline = true,
	},
})
