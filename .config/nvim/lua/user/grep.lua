local util = require("user.util")
local buffer = require("user.buffer")

local M = {}

local function ft_to_rg(ft)
    local lookup = {
        python = "py",
        javascript = "js",
        vim = "vimscript",
    }
    local ret = lookup[ft]

    if not ret then
        -- some are the same c, cpp etc
        ret = ft
    end
    return ret
end

local function grep_opts(opts)
    -- opts {
    --   dir   - starting directory, leave nil to use cwd, use "#" to use current buffer dir
    --   glob  - file pattern, eg *.py, or !*.py
    --   ftype - rg filetype eg py, vim filetypes are converted to rg equiv
    --   word  - bool, use word boundary in search, default false
    --   regex - bool, use regex in search, default false
    --   term  - search for this term, use nil for current word
    --   prompt - bool, prompt for term
    -- }
    local ret = {
        additional_args = {},
    }

    if opts.dir then
        ret.cwd = util.fif(opts.dir == "#", buffer.dirvish_or_buffer_dir(), opts.dir)
    end

    if type(opts.glob) == "string" and #opts.glob > 0 then
        -- although builtin.live_grep has glob_pattern, builtin.grep_string doesn't
        -- use additional_args as lowest common denominator
        table.insert(ret.additional_args, "--glob=" .. opts.glob)
    end

    if type(opts.ftype) == "string" and #opts.ftype > 0 then
        local type_filter = ft_to_rg(opts.ftype)
        table.insert(ret.additional_args, "--type=" .. type_filter)
    end

    if opts.word then
        table.insert(ret.additional_args, "-w")
    end

    if opts.regex then
        -- grep_string only
        ret.use_regex = true
    end

    if opts.term or opts.prompt then
        -- grep_string only
        local search = opts.term
        if opts.prompt then
            vim.ui.input({ prompt = "grep: " }, function(value)
                search = value
            end)

            if not search then
                -- cancelled
                return false
            end
        end
        ret.search = search
    end

    return ret
end

function M.grep(func, opts)
    -- func = grep_string or live_grep
    local params = grep_opts(opts)
    if params then
        func(params)
    end
end

return M
