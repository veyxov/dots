local map = require'globals'.Map
local cmd = require'globals'.Cmd

map('<leader>t', cmd [[lua vim.fn.jobstart({ 'tmux', 'neww', 'make tust ; read' })]])

vim.g["test#csharp#runner"] = "xunit"
vim.g["test#cs#xunit#executable"] ='dotnet test'
vim.g["test#strategy"] = "neovim"
