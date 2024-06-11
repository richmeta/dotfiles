local M = {}
local util = require("user.util")

function M.id()
    return vim.api.nvim_get_current_buf()
end

function M.expand_expr(typ)
    -- returns the expand equiv of `typ`
    -- where typ in 'dir', 'directory', 'filename', 'full', 'fullpath', 'stem'
    local base = vim.o.filetype == 'dirvish' and "<cfile>" or "%"
    if typ == "dir" or typ == "directory" then
        return base .. ":~:h"   -- like :p:h but expands with home dir
    elseif typ == "filename" then
        return base .. ":t"
    elseif typ == "full" or typ == "fullpath" then
        return base .. ":p"
    elseif typ == "stem" then
        return base .. ":t:r"
    elseif typ == "current" then
        return base
    end

    error("unknown value for `typ` : " .. typ)
end

function M.expand(typ)
    if typ == nil then
        typ = "current"
    end
    return util.expand(M.expand_expr(typ))
end

function M.dir()
    return M.expand("dir")
end

function M.filename()
    return M.expand("filename")
end

function M.full()
    return M.expand("full")
end

function M.stem()
    return M.expand("stem")
end

function M.has_filetype()
    return vim.bo.filetype ~= ""
end

function M.has_filename()
    return vim.fn.expand("%") ~= ""
end

function M.dirvish_or_buffer_dir()
    -- return:
    --  current dir if dirvish window
    --  otherwise current buffer's dir if not empty buffer
    --  otherwise nil
    if vim.o.filetype == "dirvish" then
        return util.expand("%")
    end
    if M.has_filename() then
        return M.expand("dir")
    end
    return nil
end

M.fullpath = M.full


return M
