vim.g.mapleader = " "

-- Center search results
Map('n', 'n', 'nzz')
Map('n', 'N', 'Nzz')

-- Normal mode inside terminal
Map ('t', '<ESC>', '<C-\\><C-n>')

-- Yanking
Map('n', 'Y', 'y$')
Map('n', '<leader>y', '"+y')
Map('n', '<leader>ya', Cmd '%y+')

-- Change the dir to current file dir
Map('n', '<leader>cd', Cmd 'tcd %:h')

-- Better indenting
Map('v', '<', '<gv')
Map('v', '>', '>gv')

-- Pasting
Map('n', 'p', 'p==') -- Paste and indent
Map('v', 'p', '"_dP') -- Paste without yanking

-- Resizing panes
Map('n', '<Up>', Cmd 'resize -1')
Map('n', '<Down>', Cmd 'resize +1')
Map('n', '<Left>', Cmd 'vertical resize +1')
Map('n', '<Right>', Cmd 'vertical resize -1')

-- Saving and quiting
Map('n', '<leader>q', Cmd 'q')
Map('n', '<leader>w', Cmd 'wall')

-- Editing configuration
Map('n', '<F12>', Cmd ':wall<bar>so $MYVIMRC <bar> PackerSync')
vim.cmd [[ nnoremap <F11> :<c-r>=@% == '' ? 'e $MYVIMRC' : 'tabnew $MYVIMRC'<cr><cr> ]]

-- Telescope
Map('n', "<leader>f'", Cmd 'Telescope marks') -- Marks
Map('n', '<leader>fG', Cmd 'Telescope live_grep') -- Grep
Map('n', '<leader>fh', Cmd 'Telescope help_tags') -- Help
Map('n', '<leader>ff', Cmd 'Telescope find_files') -- Find
Map('n', '<leader>fj', Cmd 'Telescope jumplist') -- Jumplist
Map('n', '<leader>fd', Cmd 'Telescope zoxide list') -- Zoxide
Map('n', '<leader>fm', Cmd 'Telescope man_pages') -- Man pages
Map('n', '<leader>fc', Cmd 'Telescope colorscheme') -- colorscheme
Map('n', '<leader>fo', Cmd 'Telescope file_browser file_browser') -- File Browser
Map('n', '<leader>fg', Cmd 'Telescope current_buffer_fuzzy_find') -- Grep only cur

-- Zen
Map('n', '<leader>zf', Cmd 'TZFocus')
Map('n', '<leader>zz', Cmd 'TZAtaraxis')
Map('n', '<leader>zm', Cmd 'TZMinimalist')

-- Git
Map('n', '<leader>gg', Cmd 'G')

-- LSP
Map('n', '<C-K>', Cmd 'Lspsaga hover_doc')
Map('n', '<leader>lr', Cmd 'Lspsaga rename')
Map('n', '<leader>la', Cmd 'Lspsaga code_action')
Map('n', '<leader>ls', Cmd 'Lspsaga signature_help')
Map('n', '<leader>lt', Cmd 'Lspsaga toggle_floaterm')

Map('n', '<leader>ldj', Cmd 'Lspsaga diagnostic_jump_next')
Map('n', '<leader>ldk', Cmd 'Lspsaga diagnostic_jump_prev')
Map('n', '<leader>ldd', Cmd 'Lspsaga show_cursor_diagnostics')

-- Built-in LSP functionality
Map('n', '<leader>gd', Cmd 'lua vim.lsp.buf.definition()')
Map('n', '<leader>gD', Cmd 'lua vim.lsp.buf.declaration()')
Map('n', '<leader>gi', Cmd 'lua vim.lsp.buf.implementation()')
Map('n', '<leader>gr', Cmd 'lua vim.lsp.buf.references()')
Map('n', '<leader>lf', Cmd 'lua vim.lsp.buf.formatting(nil, 1000)');

-- Trouble
Map ('n', '<leader>tr', Cmd 'TroubleToggle')

-- Buffers
Map ('n', '<leader>fw', Cmd 'BufferLinePick')

Map ('n', '<leader>1', Cmd 'BufferLineGoToBuffer 1')
Map ('n', '<leader>2', Cmd 'BufferLineGoToBuffer 2')
Map ('n', '<leader>3', Cmd 'BufferLineGoToBuffer 3')
Map ('n', '<leader>4', Cmd 'BufferLineGoToBuffer 4')
Map ('n', '<leader>5', Cmd 'BufferLineGoToBuffer 5')

-- Packer
Map ('n', '<leader>pi', Cmd 'PackerSync')
Map ('n', '<leader>ps', Cmd 'PackerStatus')
Map ('n', '<leader>pc', Cmd 'PackerCompile')

-- Misc

-- Don't move the cursor when concating lines
Map ('n', 'J', 'mzJ`z')

-- Sort current selection with line length
Map ('v', '<leader>ss', [[:'<,'> ! awk '{ print length(), $0 | "sort -n | cut -d\\  -f2-" }'<CR>]])

-- EZ commands
Map ('n', '<leader>;', ':')

-- NVim-DAP
Map ('n', '<F10>', Cmd 'lua require"dap".step_into()')
Map ('n', '<F9>', Cmd 'lua require"dap".toggle_breakpoint()')
Map ('n', '<F6>', Cmd 'lua require"dap".step_over()')
Map ('n', '<F5>', Cmd 'lua require"dap".continue()')
Map ('n', '<leader>dn', Cmd 'lua require"dap".run_to_cursor()')
Map ('n', '<leader>dk', Cmd 'lua require"dap".up()')
Map ('n', '<leader>dj', Cmd 'lua require"dap".down()')
Map ('n', '<leader>dq', Cmd 'lua require"dap".terminate()')
Map ('n', '<leader>dd', Cmd 'lua require"dap.ui.widgets".hover()')
Map ('n', '<leader>d?', ':lua local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>')

-- Tree
Map ('n', '<c-n>', Cmd 'NvimTreeToggle')
