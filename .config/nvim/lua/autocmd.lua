local autocmd = vim.api.nvim_create_autocmd

local group = vim.api.nvim_create_augroup('WEXOV', { clear = true })

autocmd('BufWritePost', {
    pattern = '*.lua',
    callback = function()
        vim.cmd "source <afile>"
        vim.cmd "PackerCompile"
    end,
    group = group,
})

autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 250 })
    end,
    group = group,
})

autocmd('CursorHold', {
    desc = 'Show current line diagnostics',
    callback = function()
        vim.diagnostic.open_float(nil, { scope = 'cursor', focusable = false, border = 'single' })
    end,
    group = group,
})

autocmd('BufWritePost', {
    pattern = '*.kbd',
    command = [[!killall kmonad ; kmonad -w 500 "$HOME/.config/keyboard/colex.kbd" &]],
    group = group,
})


autocmd('BufWritePre', {
    callback = function ()
        vim.lsp.buf.formatting_sync()
    end,
    group = group,
})

-- Disable comment new line
autocmd("BufWinEnter", {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove { "c", "r", "o" }
    end,
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
-- Enable spellchecking in markdown, text and gitcommit files
autocmd("FileType", {
   pattern = { "gitcommit", "markdown", "text" },
   callback = function()
      vim.opt_local.spell = true
   end,
})
