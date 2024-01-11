local util = require("user.util")
local mp = require("user.map")

mp.nnoremap_b("<c-t>", function()
    local line = vim.fn.getline(".")
    local st, en = line:find("^.*|%d")
    local filename = line:sub(st, en-2)
    util.execute(":tabedit " .. filename)
end)

