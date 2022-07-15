local M = {}

M.Map = function(l, r, m)
    m = m or "n" -- Default to normal mode
    vim.keymap.set(m, l, r)
end
M.Cmd = function(x) return string.format("<CMD>%s<CR>", x) end

return M
