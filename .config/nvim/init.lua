require 'impatient'

require 'plugins'
require 'options'
require 'autocmd'
require 'mapings'

-- Copilot stuff
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-T>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
