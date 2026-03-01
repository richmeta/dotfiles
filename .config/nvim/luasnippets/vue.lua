
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node

return {
    -- 
    s( { trig = "!comp", dscr = "initial component", snippetType = "autosnippet" },
        t{
            "<script setup>",
            "</script>",
            "",
            "<template>",
            "</template>",
            "",
            "<style scoped>",
            "</style>"
        }
    ),

    s( { trig = "props", dscr = "define properties" }, t{
"const props = defineProps({",
"  thing: {",
"    type: Object,",
"    required: true",
"  },",
"  tooltip: {",
"    type: String,",
"    required: false,",
"  },",
"  enabled: {",
"    type: Boolean,",
"    required: false,",
"    default: true,",
"  },",
"})",
}
    ),
        
    s( { trig = "cl", dscr = "console log" },
        fmt('console.log({});', i(0))
    ),

    s( { trig = "ce", dscr = "console error" },
        fmt('console.error({});', i(0))
    ),
}
