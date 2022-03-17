local ls = require 'luasnip'
local types = require "luasnip.util.types"

local s = ls.s
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local f = ls.function_node

local fmt = require 'luasnip.extras.fmt'.fmt
local rep = require 'luasnip.extras'.rep

ls.config.set_config {
    -- This tells LuaSnip to remember to keep around the last snippet.
    -- You can jump back into it even if you move outside of the selection
    history = true,

    -- This one is cool cause if you have dynamic snippets, it updates as you type!
    updateevents = "TextChanged,TextChangedI",

    -- Autosnippets:
    enable_autosnippets = true,

    -- Crazy highlights!!
    -- #vid3
    -- ext_opts = nil,
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { "<-", "Error" } },
            },
        },
    },
}


ls.snippets = {
    lua = {
        s('req', fmt("local {} = require '{}'", { i(1, "module"), rep(1) })),
    },

    cs = {
        s('prop',
        fmt("public {} {} {{ get; set; }}\n{}", { i(1, "string"), i(2, "Name"), i(0) })),

        s('class',
        fmt(
        [[
        public class {}
        {{
            {}
        }}
        ]], { i(1, "name"), i(0) } )),

        s('api',
            fmt(
                [[
                    [Http{}("{}")]
                    public async Task<IActionResult> {}Async()
                    {{
                        {}
                        return Ok();
                    }}
                ]],
            { i(1, "Get"), i(2, "Test"), rep(2), i(0) }
            )
        ),
    }
}
