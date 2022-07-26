local map = require'globals'.Map
local cmd = require'globals'.Cmd

map('<leader>t', cmd [[lua vim.fn.jobstart({ 'tmux', 'neww', 'make tust ; read' })]])
