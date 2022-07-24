local Map = require 'globals'.Map
local Cmd = require 'globals'.Cmd

Map ("<leader>y", '"+y')
Map ("<leader>q",  Cmd "q")
Map ("<leader>w",  Cmd "wall")

Map ("<leader>g", Cmd "LazyGit")

-- Lsp
Map ("<A-Enter>",  Cmd "Lspsaga code_action")
-- First select the region, unselect and run range_code_action
Map ("<A-Enter>",  string.format("%s %s","<ESC>" ,Cmd "Lspsaga range_code_action"), "v")
Map ("<leader>ld", Cmd "lua vim.lsp.buf.implementation()")
Map ("<leader>lD", Cmd "lua vim.lsp.buf.definition()")
Map ("<leader>lf", Cmd "Lspsaga lsp_finder")
Map ("<leader>lF", Cmd "lua vim.lsp.buf.formatting()")
Map ("<leader>lr", Cmd "Lspsaga rename")
Map ("<leader>pd", Cmd "Lspsaga preview_definition")

Map ("<C-K>",      Cmd "Lspsaga hover_doc")
Map ("<C-T>",      Cmd "Lspsaga open_floaterm")
Map ("<C-T>",      Cmd "Lspsaga close_floaterm", "t")

Map ("<leader>rr", "<Plug>RestNvim")
Map ("<leader>rp", "<Plug>RestNvimPreview")
Map ("<leader>r.", "<Plug>RestNvimLast")

Map("<C-c>", Cmd ":%y+") -- copy whole file content

-- Movement between tabs
Map("<leader>n", Cmd "tabprevious")
Map("<leader>o", Cmd "tabnext")

-- Packer
Map("<leader>ps", Cmd "PackerSync")

-- Tree
Map("\\", Cmd "Neotree toggle right")
Map("<leader>\\", Cmd "Neotree toggle show buffers right")
