local Path = require("plenary.path")
local M = {}

function M.root(silent)
    local dir = vim.fn["FugitiveExtractGitDir"](".")
    if dir == "" then
        return M.no_git(silent)
    end
    -- remove trailing .git/ dir
    local p1 = Path:new(dir)
    return tostring(p1:parent())
end

function M.relative_from_buffer(filename)
    local dir = vim.fn.FugitiveExtractGitDir(".")
    if dir == "" then
        -- not a git dir
        return vim.fn.expand("%")
    end
    local p = vim.fn.FugitivePath(filename, "")
    return tostring(Path:new(p))
end

function M.branch(silent)
    local branch = vim.fn["FugitiveHead"]()
    if branch == "" then
        return M.no_git(silent)
    end
    return branch
end

function M.no_git(silent)
    if silent ~= false then
        vim.notify("Not a git dir", vim.log.levels.ERROR)
    end
    return nil
end

return M
