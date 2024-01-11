local util = require("user.util")
local los = require("user.os")
local grep = require("user.grep")

-- Telescope
local ts_builtin = require("telescope.builtin")
local mp = require("user.map")
local file = require("user.file")
local nnoremap = mp.nnoremap

--
-- MAPPINGS
--

-- \pp = files in cwd (telescope)
nnoremap("<leader>pp", function()
    local dir
    if vim.o.filetype == "dirvish" then
        dir = util.expand("%")
    else
        dir = vim.fn.getcwd()
    end

    if file.path_equal(dir, los.home_dir) then
        vim.notify("find_files: disabled in HOME", vim.log.levels.INFO)
    else
        ts_builtin.find_files()
    end
end)

-- \gr = cwd grep prompt (telescope)
nnoremap("<leader>gr", function()
    grep.grep(ts_builtin.grep_string, {
        prompt = true,
        word = vim.g.grep_word_boundary,
        glob = vim.g.grep_glob,
        ftype = vim.g.grep_filetype,
    })
end)

-- \br = buffer grep prompt (telescope)
nnoremap("<leader>br", function()
    grep.grep(ts_builtin.grep_string, {
        prompt = true,
        dir = "#",
        word = vim.g.grep_word_boundary,
        glob = vim.g.grep_glob,
        ftype = vim.g.grep_filetype,
    })
end)

-- TODO:
-- grep visual selected

-- \gw = cwd grep current word (telescope)
nnoremap("<leader>gw", function()
    grep.grep(ts_builtin.grep_string, {
        word = vim.g.grep_word_boundary,
        glob = vim.g.grep_glob,
        ftype = vim.g.grep_filetype,
    })
end)

-- \bw = buffer grep current word (telescope)
nnoremap("<leader>bw", function()
    grep.grep(ts_builtin.grep_string, {
        dir = "#",
        word = vim.g.grep_word_boundary,
        glob = vim.g.grep_glob,
        ftype = vim.g.grep_filetype,
    })
end)

--  \lg = live grep (telescope)
nnoremap("<leader>lg", function()
    grep.grep(ts_builtin.live_grep, {
        word = vim.g.grep_word_boundary,
        glob = vim.g.grep_glob,
        ftype = vim.g.grep_filetype,
    })
end)

-- \R = last telescope picker
nnoremap("<leader>R", ts_builtin.resume)
