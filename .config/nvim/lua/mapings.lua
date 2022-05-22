Map = require 'globals'.Map;
Cmd = require 'globals'.Cmd;

Map ("<leader>y", '"+y')

-- Mappings
Map ("<leader>q", Cmd "q")
Map ("<leader>w", Cmd "wall")

-- Telescope
Map ('<C-F>', Cmd 'Telescope')
Map ('<leader>ff',      Cmd 'Telescope find_files')
Map ("<leader>fc", Cmd "Telescope colorscheme")
Map ("<leader>fh", Cmd "Telescope help_tags")
Map ("<leader>fg", Cmd "Telescope live_grep")

Map ("<C-N>", Cmd "Neotree filesystem toggle")

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
Map ('<leader>hh',  Cmd 'lua require("harpoon.mark").add_file()')
Map ('<leader>ha', Cmd 'lua require("harpoon.ui").nav_file(1)')
Map ('<leader>hr', Cmd 'lua require("harpoon.ui").nav_file(2)')
Map ('<leader>hs', Cmd 'lua require("harpoon.ui").nav_file(3)')
Map ('<leader>ht', Cmd 'lua require("harpoon.ui").nav_file(4)')
Map ('<leader>hp', Cmd 'lua require("harpoon.ui").toggle_quick_menu()')

-- GIT
Map('<leader>g', Cmd 'Gedit:')

-- Dap
Map ('<F5>', Cmd 'lua require "dap".continue()')
Map ('<F10>', Cmd 'lua require "dap".step_over()')
Map ('<F11>', Cmd 'lua require "dap".step_into()')
Map ('<F12>', Cmd 'lua require "dap".step_out()')
Map ('<leader>b', Cmd 'lua require "dap".toggle_breakpoint()')
Map ('<leader>B', Cmd 'lua require "dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))')
Map ('<leader>lp', Cmd 'lua require "dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))')
Map ('<leader>dr', Cmd 'lua require "dap".repl.open()')
Map ('<leader>dl', Cmd 'lua require "dap".run_last()')
Map ('<leader>dx', Cmd 'lua require("dap").disconnect()')

Map ("<leader>rr", "<Plug>RestNvim")
Map ("<leader>rp", "<Plug>RestNvimPreview")
Map ("<leader>r.", "<Plug>RestNvimLast")

Map("<C-c>", Cmd ":%y+") -- copy whole file content

-- Movement between tabs
Map("<leader>n", Cmd "tabprevious")
Map("<leader>o", Cmd "tabnext")
