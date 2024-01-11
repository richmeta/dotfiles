local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
    s( { trig = "#!", dscr = "shebang", snippetType = "autosnippet" },
        t{'#!/usr/bin/env bash -e', ''}
    ),
}
