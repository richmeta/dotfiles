local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s( { trig = "#!", dscr = "shebang", snippetType = "autosnippet" },
        t{'#!/usr/bin/env bash', ''}
    ),

    s( { trig = "syntax", dscr = "syntax func" }, fmt(
[[
syntax() {
    >&2 cat <<-EOF
Usage: $(basename $0) []
EOF
    exit 1
}
]],
    i(1), {delimiters = '[]'})
    ),

    s( { trig = "getopt", dscr = "getopt" }, fmt(
[=[
[[ "$1" == "--help" ]] && syntax;
while getopts "{}h" opt; do
    case $opt in
        n)
            N=$OPTARG
            ;;
        m)
            MUSIC=1
            ;;
        s)
            STUFF=1
            ;;
        h)
            syntax
            ;;
        *)
            syntax
            ;;
    esac
done

]=],
    i(1))
    ),


}
