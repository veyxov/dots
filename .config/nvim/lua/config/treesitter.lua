require'nvim-treesitter.configs'.setup {
	ensure_installed = {"lua", "cpp", "c", "vim", "c_sharp"},
	highlight = { enable = true, },
	indent = { enable = true, },
}
