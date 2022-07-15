local autocmd = vim.api.nvim_create_autocmd

local group = vim.api.nvim_create_augroup('WEXOV', { clear = true })

-- If it's a configuration file, resource it.
autocmd('BufWritePost', {
    pattern = '*.lua',
    callback = function()
        vim.cmd "source <afile>"
        vim.cmd "PackerCompile"
    end,
    group = group,
})

-- Highlight the yanked area.
autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
    end,
    group = group,
})

-- Show diagnostics when hold curson on.
autocmd('CursorHold', {
    desc = 'Show current line diagnostics',
    command = "Lspsaga show_line_diagnostics",
    group = group,
})

-- Restart the keyboard configuration deamon
autocmd('BufWritePost', {
    pattern = '*.kbd',
    command = [[!killall kmonad ; kmonad -w 500 "$HOME/.config/keyboard/colex.kbd" &]],
    group = group,
})

-- Open a file from its last left off position
autocmd("BufReadPost", {
   callback = function()
      if not vim.fn.expand("%:p"):match ".git" and vim.fn.line "'\"" > 1 and vim.fn.line "'\"" <= vim.fn.line "$" then
         vim.cmd "normal! g'\""
         vim.cmd "normal zz"
      end
   end,
})
