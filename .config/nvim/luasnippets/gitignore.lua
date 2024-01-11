local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
    s( { trig = "python", dscr = "python gitignore" },
        fmt([[
        __pycache__
        *.pyc
        *.pyo
        *.pyd
        *.log
        coverage.*
        .coverage
        venv/
        ]], {}, {})
    ),
}


