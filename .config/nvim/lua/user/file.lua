local util = require("user.util")
local buffer = require("user.buffer")
local clipboard = require("user.clip")
local git = require("user.git")
local Path = require("plenary.path")

local M = {}

local function as_path(fn)
    if Path.is_path(fn) then
        return fn
    end
    if type(fn) == "string" then
        return Path:new(util.expand(fn))  -- expand ~ or %:p patterns
    end
    error("unknown type `fn` : " .. fn)
end

M.as_path = as_path

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
        fn = string.sub(fn, 1, #fn-1)
    end
    return M.expand(fn, "stem")
end

function M.relative(fn, base_dir)
    local p1 = as_path(fn)
    return p1:make_relative(base_dir)
end

function M.strip_trailing(fn, ch)
    while string.find(fn, ch) do
        fn = string.sub(fn, 1, #fn-1)
    end
    return fn
end

function M.prompt_rename(source)
    vim.ui.input({ prompt = 'new filename: ', default = source},
        function(newfilename)
            if newfilename and newfilename ~= source then
                local cmd = string.format('!mv "%s" "%s"', source, newfilename)
                util.execute(cmd)
            end
        end
    )
end

function M.prompt_copy(source)
    vim.ui.input({ prompt = 'copy to: '},
        function(newfilename)
            if newfilename and newfilename ~= source then
                local cmd = string.format('!cp "%s" "%s"', source, newfilename)
                util.execute(cmd)
            end
        end
    )
end

function M.path_equal(a, b)
    local p1 = tostring(as_path(a))
    local p2 = tostring(as_path(b))
    return p1 == p2
end

function M.dirname(filename)
    local p1 = as_path(filename)
    return p1:parent()
end

function M.join(head, ...)
    local p1 = as_path(head)
    local p2 = p1:joinpath(...)
    return tostring(p2)
end

function M.any_exists(filenames)
    -- returns fullpath to found
    for _, fn in pairs(filenames) do
        if M.exists(fn) then
            return M.full(fn)
        end
    end
    return nil
end

function M.exists(filename)
    local p1 = as_path(filename)
    return p1:exists()
end

function M.delete(filename)
    local p1 = as_path(filename)
    vim.ui.input({ prompt = string.format("remove file '%s'? ", p1)}, function(value)
        if string.lower(value) == "y" then
            p1:rm()
            vim.notify("deleted", vim.log.levels.INFO)
        end
    end)
end

function M.delete_directory(directory)
    local p1 = as_path(directory)
    vim.ui.input({ prompt = string.format("remove directory '%s'? - 'DELETE' to confirm ", p1)}, function(value)
        if value == "DELETE" then
            p1:rm({ recursive = true })
            vim.notify("deleted", vim.log.levels.INFO)
        end
    end)
end

function M.clip(opts)
    -- opts = {
    --     path = optional, use expand or typ
    --     expand = pattern to expand into path
    --     typ = expand by type (dir, full, filename, stem, git),
    --     populates expand",
    --     showmsg = false (default)
    -- }
    local path = opts.path
    if not path then
        local expand = opts.expand
        if opts.typ == "git" then
            expand = git.relative_from_buffer(buffer.expand("current"))
        elseif opts.typ then
            expand = buffer.expand(opts.typ)
        end
        if not expand then
            error("expecting `expand` or `typ` option when `path` is omitted")
        end
        path = M.full(expand)
        -- path = tostring(Path:new(util.expand(expand)))   -- fullpath
    end

    clipboard.copy(path)

    -- also place result in reg f
    vim.fn.setreg("f", path)
    if opts.showmsg then
        vim.notify("copied", vim.log.levels.INFO)
    end
end


return M
