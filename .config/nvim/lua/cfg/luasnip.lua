local ls = require"luasnip"
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local postfix = require("luasnip.extras.postfix").postfix

local types = require "luasnip.util.types"

local s = ls.s
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local f = ls.function_node

local fmt = require 'luasnip.extras.fmt'.fmt
local rep = require 'luasnip.extras'.rep

ls.snippets = {

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

    }
}

ls.add_snippets("cs", {
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
})

ls.add_snippets("cs", {
        s('test',
            fmt(
                [[
                    [Fact]
                    public async Task {}()
                    {{
                        // Arrange
                        {}
                        // Act
                        {}
                        // Assert
                        {}
                    }}
                ]],
            { i(1, "TestName"), i(2, ""), i(3, ""), i(4, "") }
            )
        ),
})

ls.add_snippets("cs", {
        s('class',
            fmt(
                [[
                public class {}
                {{
                    {}
                }}
                ]],
            { i(1, "Name"), i(2, "") }
            )
        ),
})

ls.add_snippets("cs", {
        s('prop',
            fmt(
                [[
                public {} {} {{ get; set; }}
                {}
                ]],
            { i(1, "string"), i(2, "Name"), i(0) }
            )
        ),
})

ls.add_snippets("cs", {
        s('mediator',
            fmt(
                [[
                var command = new {}Command({});
                var handler = new {}CommandHandler({});

                var result = await handler.Handle(command, CancelationToken.None);
                {}
                ]],
            { i(1, "Name"), i(2), rep(1), i(3), i(0) }
            )
        ),
})

ls.add_snippets("cs", {
        s('handler',
            fmt(
                [[
                public record {}Command({}) : IRequest<{}>;

                public class {}CommandHandler : IRequestHandler<{}Command, {}>
                {{
                    public {}CommandHandler({})
                    {{
                    }}

                    public async Task<{}> Handle({}Command request, CancellationToken cancelationToken)
                    {{
                        {}
                    }}
                }}
                ]],
            { i(1, "Name"), i(2), i(3), rep(1), rep(1), rep(3), rep(1), i(4), rep(3), rep(1), i(0) }
            )
        ),
})

ls.add_snippets("cs", {
        s('validator',
            fmt(
                [[
                public class {}Validator : AbstractValidator<{}Command>
                {{
                    public {}Validator()
                    {{
                        {}
                    }}
                }}
                ]],
            { i(1, "Name"), rep(1), rep(1), i(0) }
            )
        ),
})
