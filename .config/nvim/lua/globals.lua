-- Set mapings in normal mode (most of the cases)
function Map(mode, x, y) vim.api.nvim_set_keymap(mode, x, y, { noremap = true, silent = true }) end
-- Shorthand for runing :*COMMAND*<CR>
function Cmd(what)       return string.format('<CMD>%s<CR>', what) end
