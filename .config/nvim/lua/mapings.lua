vim.g.mapleader = " "

-- nnoremap
local Map = function(l, r) vim.keymap.set("n", l, r) end
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
Map ("<leader>a", Cmd "lua vim.lsp.buf.code_action()")
Map ("<leader>d", Cmd "lua vim.lsp.buf.definition()")
Map ("<leader>lf", Cmd "lua vim.lsp.buf.formatting()")

-- Resizing panes
Map('<Up>', Cmd 'resize -5')
Map('<Down>', Cmd 'resize +5')
Map('<Left>', Cmd 'vertical resize +5')
Map('<Right>', Cmd 'vertical resize -5')

-- GIT
Map('<leader>g', Cmd 'G')
