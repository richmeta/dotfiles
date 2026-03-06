local M = {}

local function git_root()
    local git_root = vim.fn.FugitiveWorkTree()
    if git_root == "" then
        -- not a git dir
        return ""
    end

    if vim.g.project_root then
        -- allow overriding for projects where root != git
        return vim.g.project_root
    else
        return git_root
    end
end

local function git_branch()
    return vim.fn.FugitiveHead()
end

function M.root(silent)
    local dir = git_root()
    if dir == "" then
        return M.no_git(silent)
    end
    return dir
end

function M.absolute(filename)
    local dir = git_root()
    if dir == "" then
        return vim.fn.expand("%:p")
    end
    
    return vim.fn.FugitivePath(filename, dir)
end

function M.relative_from_root(filename)
    local dir = git_root()
    if dir == "" then
        return vim.fn.expand("%")
    end

    if vim.g.project_root then
        local file = require("user.file")
        return file.relative(filename, vim.g.project_root)
    else
        return vim.fn.FugitivePath(filename, "")
    end
end

function M.branch(silent)
    local branch = git_branch()
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
