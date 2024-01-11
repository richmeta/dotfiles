local M = {}

local file = require("user.file")
local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local sn = ls.snippet_node
local d = ls.dynamic_node
local i = ls.insert_node
local t = ls.text_node

-- works as visual
-- places selected text OR sets jump-index to `ji`
function M.visual(ji)
    return d(1, function(_, snip)
        local selection = snip.env.LS_SELECT_RAW
        if #selection > 0 then
            return sn(nil, t(selection))
        else
            return sn(nil, i(ji))
        end
    end, {})
end

-- function M.snip_tmpl(path, nodes, opts)
function M.snip_tmpl(ft, name, nodes, opts)
    local fullpath = file.join(vim.fn.stdpath("config"), "luasnippets", "templates", ft, string.format("%s.tmpl", name))

    local lines = {}
    for line in io.lines(fullpath) do
        table.insert(lines, line)
    end

    local template = table.concat(lines, "\n")
    return fmt(template, nodes, opts)
end


return M
