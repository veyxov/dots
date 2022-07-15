local Cmd = require 'globals'.Cmd
local Hydra = require("hydra")

Hydra({
	name = "Change / Resize Window",
	mode = 'n',
	body = "<C-w>",
    config = {
        hint = false -- Don't show hints
	},
	heads = {
		-- equalize window sizes
		{ "e", "<C-w>=" },
        { "s", Cmd "new" },
        { "v", Cmd "vnew" },

        -- Moving around
        { '<up>', '<C-W>k' },
        { '<down>', '<C-W>j' },
        { '<left>', '<C-W>h' },
        { '<right>', '<C-W>l' },

        -- Resizing
        { '<s-up>', '<C-w>2+' },
        { '<s-down>', '<C-w>2-' },
        { '<s-left>', '<C-w>3<' },
        { '<s-right>', '<C-w>3>' },

        { 'f', Cmd 'Telescope find_files' },

		-- close active window
		{ "q", ":q<cr>" },

		-- exit this Hydra
		{ "<Esc>", nil, { exit = true, nowait = true } },
	},
})

Hydra({
   name = 'Side scroll',
   mode = 'n',
   body = 'z',
   heads = {
      { '<left>', '5zh' },
      { '<right>', '5zl', { desc = '←/→' } },
      { '<up>', 'zH' },
      { '<down>', 'zL', { desc = 'half screen ←/→' } },
   }
})

-- Telescope 
Hydra({
    name = 'Telescope',
    mode = 'n',
    body = '<leader>f',
    config = {
        hint = false
    },
    heads = {
        { 'f', ':Telescope git_files<CR>', desc = "git managed files" },
        { 'g', ':Telescope live_grep<CR>', desc = "seach inside files" },
        { 'h', ':Telescope help_tags<CR>', desc = "seach help" },
    }
})

Hydra({
    name = 'Debugger',
    mode = 'n',
    hint = "Debugger",
    body = '<C-G>',
    config = {
        color = 'pink',
    },

    heads = {
        { 's', Cmd 'lua require "dap".continue()' },
        { 'n', Cmd 'lua require "dap".step_over()' },
        { 'i', Cmd 'lua require "dap".step_into()' },
        { 'o', Cmd 'lua require "dap".step_out()' },
        { 'b', Cmd 'lua require "dap".toggle_breakpoint()' },
        { 'x', Cmd 'lua require "dap".disconnect()' },
    }
})
