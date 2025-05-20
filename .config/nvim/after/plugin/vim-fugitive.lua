local util = require("user.util")
local clipboard = require("user.clip")
local file = require("user.file")
local buffer = require("user.buffer")
local git = require("user.git")
local mp = require("user.map")

-- \wg = change working directory to git root
mp.nnoremap("<Leader>wg", function()
    local gitdir = git.root()

    if gitdir then
        util.execute('cd ' .. gitdir)
        util.execute('pwd')
    end
end)

-- \cb = copy git branch name
mp.nnoremap("<Leader>cb", function()
    local branch = git.branch()
    if branch then
        clipboard.copy(branch)
    end
end)

-- \cg = copy git path relative
mp.nnoremap("<Leader>cg", function()
    -- git path else current buffer
    file.clip({ typ = "git", showmsg = true })
end)

if vim.fn.executable('gh') then
    -- \gl = copy url to current file (main)
    mp.nnoremap("<Leader>gl", function()
        -- gh runs relative to cwd
        local line = vim.fn.line(".")
        local full = buffer.expand("full")
        local path = file.relative(full, file.cwd())
        local exec = string.format("gh browse -n %s:%d", path, line)
        local result = vim.fn.system(exec)
        clipboard.copy(result)
        vim.notify("copied", vim.log.levels.INFO)
    end, mp.buffer)

    -- \gL = copy url to current file on branch
    mp.nnoremap("<Leader>gL", function()
        -- gh runs relative to cwd
        local line = vim.fn.line(".")
        local branch = git.branch()
        local full = buffer.expand("full")
        local path = file.relative(full, file.cwd())
        local exec = string.format("gh browse -n %s:%d -b %s", path, line, branch)
        local result = vim.fn.system(exec)
        clipboard.copy(result)
        vim.notify("copied", vim.log.levels.INFO)
    end, mp.buffer)
end

