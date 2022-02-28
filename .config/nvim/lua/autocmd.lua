local groupname = "WEXOUV"

-- @param {boolean} clear - optional, defaults to true
-- @param {string} name - autogroup name
vim.api.nvim_create_augroup({ name = groupname, clear = true })

-- @param {string} name - augroup name
-- @param {string | table} event - event or events to match against
-- @param {string | table} pattern - pattern or patterns to match against
-- @param {string | function} callback - function or string to execute on autocmd
-- @param {string} command - optional, vimscript command Eg. command = "let g:value_set = v:true"
-- @param {boolean} once - optional, defaults to false
vim.api.nvim_create_autocmd {
    event = "BufWritePost",
    group = groupname,
    pattern = "*.lua",
    callback = function() vim.cmd "so <afile>" end ,
    once = false
}

vim.api.nvim_create_autocmd {
    event = "TextYankPost",
    group = groupname,
    pattern = "*",
    callback = function() vim.highlight.on_yank { higroup = "IncSearch", timeout = 1000 } end ,
    once = false
}
