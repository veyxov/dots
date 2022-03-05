local name = "WEXOUV"

vim.api.nvim_create_augroup(name, {})


-- Recompile and update plugins
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = "plugins.lua",
    group = name,
    command = "exe 'luafile <afile>' | exe 'PackerSync'",

    desc = "Recompile the plugins"
})

-- Show highlighted region
vim.api.nvim_create_autocmd('TextYankPost', {
    group = name,
    callback = function ()
        vim.highlight.on_yank {
            higroup = 'IncSearch',
            on_macro = true
        }
    end
})
