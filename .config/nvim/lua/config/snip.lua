local ls = require 'luasnip'
local fmt = require 'luasnip.extras.fmt'.fmt
local snip = ls.s
local i = ls.insert_node
local rep = require 'luasnip.extras'.rep

ls.snippets = {
    all = {
        snip("req", fmt("local {} = require('{}')", { i(1, "default"), rep(1)}))
    },

    cs = {
        ls.parser.parse_snippet(
            "prop",
            "public ${1:string} ${2:Name} { get; set; }"
        )
    }
}
