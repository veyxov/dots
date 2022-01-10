-- Setup nvim-cmp.
local cmp = require 'cmp'
local lspkind = require 'lspkind'
local luasnip = require 'luasnip'

lspkind.init({
	symbol_map = {
		Enum = '',
		File = '',
		Text = '',
		Unit = '塞',
		Class = 'ﴯ',
		Color = '',
		Event = '',
		Field = 'ﰠ',
		Value = '',
		Folder = '',
		Method = '',
		Module = '',
		Struct = 'פּ',
		Keyword = '',
		Snippet = '',
		Constant = '',
		Function = '',
		Operator = '',
		Property = 'ﰠ',
		Variable = '',
		Interface = '',
		Reference = '',
		EnumMember = '',
		Constructor = '',
		TypeParameter = ''
	}
})


cmp.setup({
	formatting = {
		format = lspkind.cmp_format {
			with_text = true,
			maxwidth = 55,
			menu = {
				treesitter = '[TREE]',
				buffer     = '[BUFF]',
				nvim_lsp   = '[LSP]',
				path       = '[PATH]',
				luasnip    = '[SNIP]',
			}
		}
	},
	experimental = {ghost_text = true},
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end
	},
	mapping = {
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
			elseif cmp.visible()            then cmp.select_next_item()
			else                            fallback()
            end
		end, {'i', 's'})
	},
	sources = {
		{
			name = 'buffer',
			option = {
				get_bufnrs = function()
					local bufs = {}
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						bufs[vim.api.nvim_win_get_buf(win)] = true
					end
					return vim.tbl_keys(bufs)
				end,
			},
		},
		{name = 'path'},
		{name = 'luasnip'},
		{name = 'nvim_lsp'},
		{name = 'treesitter'}
	}
})

-- Use buffer source for `/`.
cmp.setup.cmdline('/', {sources = {{name = 'buffer'}}})

-- Use cmdline & path source for ':'.
cmp.setup.cmdline(':', { sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}}) })

-- From friendly snippets
require('luasnip/loaders/from_vscode').lazy_load()
