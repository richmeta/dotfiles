local file = require("user.file")
local util = require("user.util")
local los = require("user.os")
local grep = require("user.grep")
local scan = require("plenary.scandir")
local ts_builtin = require("telescope.builtin")

-- sudo write
vim.api.nvim_create_user_command(
    'W',
    function()
        print("Password: ")
        vim.fn.execute("write !sudo tee % >/dev/null")
        vim.fn.execute("silent! edit!")
    end,
    {
        nargs = 0
    }
)

-- :WX = save + chmod+x
vim.api.nvim_create_user_command(
    'WX',
    function()
        vim.fn.execute("write")
        vim.fn.execute("write !chmod a+x % >/dev/null")
        vim.fn.execute("silent! edit!")
    end,
    {
        nargs = 0
    }
)

-- Vgrep = search nvim lua config for key maps
-- regex = '^\s*".*<args>.*=' in luadir
vim.api.nvim_create_user_command(
    'Vgrep',
    function(opts)
        local arg = opts.args:gsub('\\', '\\\\')    -- need double delimited for leader mappings
        local cmd = string.format("silent grep! '^\\s*--.*%s' %s", arg, los.nvim_config_dir)
        util.execute(cmd)
        util.execute("cwindow")
    end,
    { nargs = 1 }
)

-- Ngrep = search commands wiki
vim.api.nvim_create_user_command(
    'Ngrep',
    function(opts)
        local cmd = string.format("silent grep! %s %s", opts.args, vim.g.sync_commands_dir)
        util.execute(cmd)
        util.execute("cwindow")
    end,
    { nargs = 1 }
)

local nopen_complete_func = function(arglead)
    local pat = "^" .. arglead
    local ret = {}
    local found = scan.scan_dir(vim.g.sync_commands_dir, { search_pattern = arglead })

    -- further match on filename only
    for _, v in ipairs(found) do
        local filename = file.filename(v)
        if filename:match(pat) then
            table.insert(ret, filename)
        end
    end
    return ret
end

-- Nopen = open from sync commands
vim.api.nvim_create_user_command(
    'Nopen',
    function(opts)
        local filename = opts.args
        local path = file.join(vim.g.sync_commands_dir, vim.fn.trim(filename))

        if not path:match(".wiki$") then
            local altpath = path .. ".wiki"
            if file.exists(altpath) then
                path = altpath
            end
        end

        if opts.bang then
            util.execute('edit ' .. path)
        else
            util.execute('tabedit ' .. path)
        end
    end,
    {
        nargs = 1,
        bang = true,
        complete = nopen_complete_func
    }
)

-- Grep = run grep
vim.api.nvim_create_user_command(
    'Grep',
    function(opts)
        grep.grep(ts_builtin.grep_string, {
            term = opts.args,
            word = vim.g.grep_word_boundary,
            glob = vim.g.grep_glob,
            ftype = vim.g.grep_filetype,
            regex = vim.g.grep_regex,
        })
    end,
    {
        nargs = 1
    }
)

-- GrepMode
-- args can be any of
--  regex=0|1
--  boundary=0|1
--  glob=<pattern> or empty
--  filetype=<ft> or empty
vim.api.nvim_create_user_command(
    'GrepMode',
    function(opts)
        for k, v in string.gmatch(opts.args, "(%a+)=(%S*)") do
            if k == "boundary" then
                vim.g.grep_word_boundary = tonumber(v)
            elseif k == "regex" then
                vim.g.grep_regex = tonumber(v)
            elseif k == "filetype" then
                vim.g.grep_filetype = v
            elseif k == "glob" then
                vim.g.grep_glob = ""
            end
        end
    end,
    {
        nargs = "+"
    }
)


-- R - reload lua module
vim.api.nvim_create_user_command(
    'R',
    function(opts)
        R(opts.args)
        print("ok")
    end,
    {
        nargs = "+"
    }
)

-- ClipStart
-- capture values from clipboard (when changes)
local capture_clip_timer = nil
local capture_paused = false

local function clip_stop()
    if capture_clip_timer ~= nil then
        capture_clip_timer:close()
        capture_clip_timer = nil
    end
end

local function clip_start()
    local bid = vim.api.nvim_get_current_buf()
    -- autocmd to close
    vim.api.nvim_create_autocmd({"BufDelete"}, {
        buffer = bid,
        callback = function()
            clip_stop()
        end
    })

    vim.api.nvim_create_autocmd({"BufLeave"}, {
        buffer = bid,
        callback = function()
            capture_paused = true
        end
    })

    vim.api.nvim_create_autocmd({"BufEnter"}, {
        buffer = bid,
        callback = function()
            capture_paused = false
        end
    })

    capture_clip_timer  = vim.loop.new_timer()
    local clipvalue = ""
    capture_clip_timer:start(1000, 1000, vim.schedule_wrap(function()
        if capture_paused == false then
            local current = vim.fn.getreg("+")
            if current ~= clipvalue then
                clipvalue = current
                vim.api.nvim_buf_set_lines(bid, -1, -1, true, { clipvalue })
            end
        end
    end))
end

vim.api.nvim_create_user_command('ClipStart', clip_start, {})
vim.api.nvim_create_user_command('ClipStop', clip_stop, {})
