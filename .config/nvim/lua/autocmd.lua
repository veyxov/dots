local api = vim.api

local group = api.nvim_create_augroup('WEXOV', { clear = true })

api.nvim_create_autocmd('BufWritePost', {
    pattern = '*.lua',
    callback = function()
        vim.cmd "source <afile>"
        vim.cmd "PackerCompile"
    end,
    group = group,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 250 })
    end,
    group = group,
})

vim.api.nvim_create_autocmd('CursorHold', {
    desc = 'Show current line diagnostics',
    callback = function()
        vim.diagnostic.open_float(nil, { scope = 'cursor', focusable = false, border = 'single' })
    end,
    group = group,
})
