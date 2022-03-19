local luasnip = require("luasnip")
local cmp = require("cmp")

local lspkind = require "lspkind"
lspkind.init()

cmp.setup({
    formatting = {
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = nil,

            menu = {
                buffer = "[BUF]",
                nvim_lsp = "[LSP]",
            }
        })
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ["<C-Y>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = {
    { name = "nvim_lsp" }, { name = "path" },
    { name = 'cmdline' }, { name = 'luasnip' },
    { name = 'nvim_lua' }, { name = 'treesitter', keyword_length = 3 },
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
            get_bufnrs = function() return vim.api.nvim_list_bufs() end,
            keyword_length = 5
        },
    },
    experimental = {
        native_menu = false,
        ghost_text = true,
    }
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

cmp.setup.cmdline(':', {
    sources = {
    { name = 'cmdline', keyword_length = 3 }
    }
})

cmp.setup.cmdline('/', {
    sources = {
    { name = 'buffer' }
    }
})

cmp.setup.cmdline('?', {
    sources = {
    { name = 'buffer' },
    }
})

cmp.setup.cmdline(':%s/', {
    sources = {
    { name = 'buffer' }
    }
})
