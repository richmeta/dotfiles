local file = require("user.file")
local util = require("user.util")
local M = {}

local cabbrev = vim.cmd.cabbrev
M.cabbrev = cabbrev

-- cs = colorscheme[c]
cabbrev("cs", "colorscheme")

-- T = tabedit[c]
cabbrev("T", "tabedit")

-- some common path abbreviations
cabbrev("_config", "~/.config")
cabbrev("_sshconfig", "~/.ssh/config")

if vim.fn.exists("$HOME/scripts") then
    cabbrev("_scripts", "~/scripts")
end


function M.cabbrev_from_dirs(dirs)
    for _, fn in ipairs(dirs) do
        local stem = string.gsub(file.stem(fn), "-", "_")  -- hypens to underscore
        stem = string.gsub(stem, "^_", "")                 -- without leading underscores
        cabbrev("_" .. stem, fn)                           -- _dir_name_thing to path/to/dir_name-thing

        if string.find(stem, "^[^_].*_") then
            stem = string.gsub(stem, "_", "")              -- no underscores version
            cabbrev("_" .. stem, fn)                       -- _dirnamething to path/to/dir_name-thing
        end
    end
end

return M
