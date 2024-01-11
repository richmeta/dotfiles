local Path = require("plenary.path")
local M = {}

function M.root()
    local dir = vim.fn["FugitiveExtractGitDir"](".")
    if dir == "" then
        return M.no_git()
    end
    -- remove trailing .git/ dir
    local p1 = Path:new(dir)
    return tostring(p1:parent())
end

function M.relative_from_buffer()
    local dir = vim.fn["FugitiveExtractGitDir"](".")
    if dir == "" then
        return vim.fn.expand("%")
    end
    local fugitive_path = vim.fn["FugitivePath"]
    return fugitive_path(vim.fn.getreg("%"), "")
end

function M.branch()
    local branch = vim.fn["FugitiveHead"]()
    if branch == "" then
        return M.no_git()
    end
    return branch
end

function M.no_git()
    vim.notify("Not a git dir", vim.log.levels.ERROR)
    return nil
end

return M
