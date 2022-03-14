vim.g.mapleader = " "

-- nnoremap
local Map = function(l, r, m)
    m = m or "n"
    vim.keymap.set(m, l, r)
end
local Cmd = function(x) return string.format("<CMD>%s<CR>", x) end

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

-- Zen
Map('<leader>zz', Cmd 'TZAtaraxis')

-- Harpoon
Map('<leader>ha', Cmd 'lua require("harpoon.mark").add_file()')
Map('<leader>hm', Cmd 'lua require("harpoon.ui").toggle_quick_menu()')
Map('<leader>1', Cmd 'lua require("harpoon.ui").nav_file(1)')
Map('<leader>2', Cmd 'lua require("harpoon.ui").nav_file(2)')
Map('<leader>3', Cmd 'lua require("harpoon.ui").nav_file(3)')
Map('<leader>4', Cmd 'lua require("harpoon.ui").nav_file(4)')
Map('<leader>5', Cmd 'lua require("harpoon.ui").nav_file(5)')
Map('<leader>ht', Cmd 'lua require("harpoon.term").gotoTerminal(1)')
Map('<leader>hh', Cmd 'Telescope harpoon marks')
