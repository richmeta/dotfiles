local M = {}

local function git_root()
    return vim.fn.FugitiveWorkTree()
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

function M.relative_from_buffer(filename)
    local dir = git_root()
    if dir == "" then
        -- not a git dir
        return vim.fn.expand("%")
    end
    return vim.fn.FugitivePath(filename, "")
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
