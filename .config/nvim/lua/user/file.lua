local util = require("user.util")
local buffer = require("user.buffer")
local clipboard = require("user.clip")
local Path = require("plenary.path")

local M = {}

function M.expand_expr(typ)
    -- returns the expand equiv of `typ`
    -- where typ in 'dir', 'directory', 'filename', 'full', 'fullpath', 'stem'
    if typ == "dir" or typ == "directory" then
        return ":~:h"   -- like :p:h but expands with home dir
    elseif typ == "filename" then
        return ":t"
    elseif typ == "full" or typ == "fullpath" then
        return ":p"
    elseif typ == "stem" then
        return ":t:r"
    elseif typ == "current" then
        return ""
    end

    error("unknown value for `typ` : " .. typ)
end

function M.expand(fn, typ)
    return vim.fn.fnamemodify(fn, M.expand_expr(typ))
end

function M.dir(fn)
    return M.expand(fn, "dir")
end

function M.filename(fn)
    return M.expand(fn, "filename")
end

function M.full(fn)
    return M.expand(fn, "full")
end

function M.stem(fn)
    if string.find(fn, "/$") then
        -- only tables are passed by reference
        fn = string.sub(fn, 1, #fn-1)
    end
    return M.expand(fn, "stem")
end

function M.prompt_rename(source)
    -- local newfilename = vim.fn.input('new filename: ', source)
    vim.ui.input({ prompt = 'new filename: ', default = source},
        function(newfilename)
            if newfilename and newfilename ~= source then
                local cmd = string.format('!mv "%s" "%s"', source, newfilename)
                util.execute(cmd)
            end
        end
    )
end

function M.path_equal(a, b)
    local p1 = tostring(Path:new(a))
    local p2 = tostring(Path:new(b))
    return p1 == p2
end

function M.dirname(filename)
    local p1 = Path:new(filename)
    return p1:parent()
end

function M.join(head, ...)
    local p1 = Path:new(head)
    local p2 = p1:joinpath(...)
    return tostring(p2)
end

function M.exists(filename)
    local p1 = Path:new(util.expand(filename))  -- expand ~ or %:p patterns
    return p1:exists()
end

function M.delete(filename)
    local p1 = Path:new(util.expand(filename))  -- expand ~ or %:p patterns
    vim.ui.input({ prompt = string.format("remove file '%s'? ", p1)}, function(value)
        if string.lower(value) == "y" then
            p1:rm()
            vim.notify("deleted", vim.log.levels.INFO)
        end
    end)
end

function M.clip(opts)
    -- opts = {
    --     path = optional, use expand or typ
    --     expand = pattern to expand into path
    --     typ = expand by type (dir, full, filename, stem),
    --     populates expand",
    --     showmsg = false (default)
    -- }
    local path = opts.path
    if not path then
        local expand = opts.expand
        if opts.typ then
            expand = buffer.expand(opts.typ)
        end
        if not expand then
            error("expecting `expand` or `typ` option when `path` is omitted")
        end
        path = tostring(Path:new(util.expand(expand)))   -- fullpath
    end

    clipboard.copy(path)

    -- also place result in reg f
    vim.fn.setreg("f", path)
    if opts.showmsg then
        vim.notify("copied", vim.log.levels.INFO)
    end
end


return M
