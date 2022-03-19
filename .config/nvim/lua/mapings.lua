Map = require 'globals'.Map;
Cmd = require 'globals'.Cmd;

-- Mappings
Map ("<leader>q", Cmd "q")
Map ("<leader>w", Cmd "wall")

-- Telescope
Map ('<C-F>', Cmd 'Telescope')
Map ('<leader>ff',      Cmd 'Telescope find_files')
Map ("<leader>fc", Cmd "Telescope colorscheme")
Map ("<leader>fh", Cmd "Telescope help_tags")
Map ("<leader>fg", Cmd "Telescope live_grep")

Map ("<C-N>", Cmd "NvimTreeToggle")

-- Lsp
Map ("<C-A>", Cmd "Lspsaga code_action")
Map ("<leader>ld", Cmd "lua vim.lsp.buf.implementation()")
Map ("<leader>lD", Cmd "lua vim.lsp.buf.definition()")
Map ("<leader>lf", Cmd "Lspsaga lsp_finder")
Map ("<leader>lF", Cmd "lua vim.lsp.buf.formatting()")
Map ("<leader>lr", Cmd "Lspsaga rename")
Map ("<leader>pd", Cmd "Lspsaga preview_definition")

Map ("<C-K>", Cmd "Lspsaga hover_doc")
Map ("<C-T>", Cmd "Lspsaga open_floaterm")
Map ("<C-T>", Cmd "Lspsaga close_floaterm", "t")

-- Harpoon
Map ('<leader>h',  Cmd 'lua require("harpoon.mark").add_file()')
Map ('<leader>ha', Cmd 'lua require("harpoon.ui").nav_file(1)')
Map ('<leader>hr', Cmd 'lua require("harpoon.ui").nav_file(2)')
Map ('<leader>hs', Cmd 'lua require("harpoon.ui").nav_file(3)')
Map ('<leader>ht', Cmd 'lua require("harpoon.ui").nav_file(4)')
Map ('<leader>hh', Cmd 'Telescope harpoon marks')

-- GIT
Map('<leader>g', Cmd 'Gedit:')
