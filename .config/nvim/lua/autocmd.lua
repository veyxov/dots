vim.cmd [[

augroup WEXOUV
	autocmd!

	au BufWritePost *.lua so <afile>
	au BufWritePost plugins.lua PackerCompile

	au TextYankPost * silent! lua vim.highlight.on_yank { higroup = "IncSearch", timeout = 1000 }

	au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup end

]]
