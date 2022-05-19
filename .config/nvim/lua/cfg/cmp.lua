local cmp = require "cmp"
local luasnip = require "luasnip"
local lspkind = require('lspkind')

local kind_icons = {
  Text = "",     Method = "m",
  Function = "", Constructor = "",
  Field = "",    Variable = "",
  Class = "",    Interface = "",
  Module = "",   Property = "",
  Unit = "",     Value = "",
  Enum = "",     Keyword = "",
  Snippet = "",  Color = "",
  File = "",     Reference = "",
  Folder = "",   EnumMember = "",
  Constant = "", Struct = "",
  Event = "",    Operator = "",
  TypeParameter = "",
}

local source_mapping = {
	buffer = "[Buffer]",
	nvim_lsp = "[LSP]",
	nvim_lua = "[Lua]",
	cmp_tabnine = "[TN]",
	path = "[Path]",
}


cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-q>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
    ["<Up>"] = cmp.mapping.select_prev_item(),
	["<Down>"] = cmp.mapping.select_next_item(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.confirm()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback()
      end
    end, { "i", "s"}),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback()
      end
    end, { "i", "s"}),
  },
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = lspkind.presets.default[vim_item.kind]
            local menu = source_mapping[entry.source.name]
            if entry.source.name == 'cmp_tabnine' then
                if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
                    menu = entry.completion_item.data.detail .. ' ' .. menu
                end
                vim_item.kind = ''
            end
            vim_item.menu = menu
            return vim_item
        end
    },
  sources = {
    { name = 'cmp_tabnine' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'spell' },
    { name = 'path' },
    { name = 'treesitter', keyword_length = 3 },
    { name = 'buffer', keyword_length = 3 },
    { name = 'nvim_lua' },
    {
        name = 'tmux',
        option = {
            all_panes = true,
            label = '[tmux]',
            trigger_characters = { '.' },
            trigger_characters_ft = {}
        }
    },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  experimental = {
    ghost_text = true,
  },
}

local compare = require('cmp.config.compare')
cmp.setup({
  sorting = {
    priority_weight = 2,
    comparators = {
      require('cmp_tabnine.compare'),
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.kind,
      compare.sort_text,
      compare.length,
      compare.order,
    },
  },
})

cmp.setup.cmdline(":", {
    completion = {autocomplete = true},

    sources = cmp.config.sources({{name = "path"}}, {
        {name = "cmdline", max_item_count = 20, keyword_length = 1}
    })
})

cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline { },
    sources = cmp.config.sources {
        { name = "buffer" },
    },
})

cmp.setup.cmdline(":%s/", {
    mapping = cmp.mapping.preset.cmdline { },
    sources = cmp.config.sources {
        { name = "buffer" },
    },
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline { },
    sources = cmp.config.sources {
        { name = "cmdline" },
        { name = "path" },
    },
})
