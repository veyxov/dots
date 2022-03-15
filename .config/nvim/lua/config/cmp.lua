local luasnip = require("luasnip")
local cmp = require("cmp")

local lspkind = require "lspkind"
lspkind.init()

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = nil,
        })
    },
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        { name = "nvim_lsp" }, { name = "path" },
        { name = 'cmdline' }, { name = 'luasnip' },
        { name = 'nvim_lua' }, { name = 'treesitter' },
        {
            name = 'tmux',
            option = {
                all_panes = true,
                label = '[tmux]',
                trigger_characters = { '.' },
                trigger_characters_ft = {}
            }
        },
        {
            name = 'buffer',
            get_bufnrs = function() return vim.api.nvim_list_bufs() end
        },
    },
    experimental = {
        native_menu = false,
        ghost_text = true,
    },
})

-- server's setup via lsp_installer
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local cmp_capabilities = require("cmp_nvim_lsp").update_capabilities

    local opts = {
        on_attach = on_attach,
        capabilities = cmp_capabilities(vim.lsp.protocol.make_client_capabilities()),
        flags = { debounce_text_changes = nil },
    }
    server:setup(opts)
    vim.cmd [[ do user lspattachbuffers ]]
end)

require'cmp'.setup.cmdline('/', {
  sources = {
    { name = 'buffer' },
    { name = 'nvim_lsp_document_symbol' }
  }
})

require'cmp'.setup.cmdline(':', {
  sources = {
    { name = 'cmdline' },
    { name = 'buffer' },
    { name = 'path' }
  }
})

