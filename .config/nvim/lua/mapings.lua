-- Mappings
Map ("<leader>q", Cmd "q")
Map ("<leader>w", Cmd "wall")

-- Telescope
Map ("<leader>ff", Cmd "Telescope find_files")
Map ("<leader>fc", Cmd "Telescope colorscheme")
Map ("<leader>fh", Cmd "Telescope help_tags")
Map ("<leader>fg", Cmd "Telescope live_grep")

Map ("<C-N>", Cmd "NvimTreeToggle")


-- Lsp
Map ("<leader>la", Cmd "Lspsaga code_action")
Map ("<leader>ld", Cmd "lua vim.lsp.buf.implementation()")
Map ("<leader>lD", Cmd "lua vim.lsp.buf.definition()")
Map ("<leader>lf", Cmd "Lspsaga lsp_finder")
Map ("<leader>lr", Cmd "Lspsaga rename")
Map ("<leader>pd", Cmd "Lspsaga preview_definition")
Map ("<C-K>", Cmd "Lspsaga hover_doc")
Map ("<C-T>", Cmd "Lspsaga open_floaterm")
Map ("<C-T>", Cmd "Lspsaga close_floaterm", "t")



-- GIT
Map('<leader>g', Cmd 'G')
