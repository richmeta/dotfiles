local util = require("user.util")
local clipboard = require("user.clip")
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
    local path = git.relative_from_buffer()
    clipboard.copy(path)
end)

