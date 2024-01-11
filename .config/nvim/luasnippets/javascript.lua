
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
-- local u = require("user.snip")
-- local rep = require("luasnip.extras").rep
-- local f = ls.function_node

return {
    -- 
    s( { trig = "#!", dscr = "shebang", snippetType = "autosnippet" },
        t{'#!/usr/bin/env node', ''}
    ),

    s( { trig = "cl", dscr = "console log" },
        fmt('console.log({});', i(0))
    ),

    s( { trig = "ce", dscr = "console error" },
        fmt('console.error({});', i(0))
    ),

}
