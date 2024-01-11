local M = {}

-- TODO
--  some lua tests
--
-- separate toggle from creating as mapping
--   toggle - function
--   map_toggle - mapping to create the toggle
--

local function get_vim_var(variable)
    local typ, name = string.match(variable, "([bg]):(%S+)")
    if typ == "g" then
        return vim.g[name]
    elseif type == "b" then
        return vim.bo[name]
    else
        error(string.format("toggler: vim variable '%s' is not in format 'g:varname' or 'b:varname'", variable))
    end
end

local function set_vim_var(variable, value)
    local typ, name = string.match(variable, "([bg]):(%S+)")
    if typ == "g" then
        vim.g[name] = value
    elseif type == "b" then
        vim.bo[name] = value
    else
        error(string.format("toggler: vim variable '%s' is not in format 'g:varname' or 'b:varname'", variable))
    end
end

local function find_next_choice(opts, current_value, choices)
    -- precondition: value must exist in choices
    if opts.handler then
        return opts.handler(current_value)
    end

    for i, v in ipairs(choices) do
        if v == current_value then
            local _, next_value = next(choices, i)
            if next_value == nil then
                next_value = choices[1]
            end
            return next_value
        end
    end

    error(string.format("Current value doesn't match choices. Add '%s' to choices '%s'.", current_value, vim.inspect(choices)))
end

local function set_next(opts, next_value)
    if opts.handler and next_value == opts.handler_ignore then
        return
    elseif opts.setting then
        vim.opt[opts.setting] = next_value
        vim.notify(string.format("%s=%s", opts.setting, next_value), vim.log.levels.INFO)
    elseif type(opts.source) == "string" then
        set_vim_var(opts.source, next_value)
    end

    if opts.callback then
        opts.callback(next_value)
    end
end

local function set_list_next(opts, next_value, old_value)
    if opts.handler and next_value == opts.handler_ignore then
        return
    elseif opts.setting then
        if old_value then
            vim.opt[opts.setting]:remove(old_value)
        end
        if next_value ~= "" then
            vim.opt[opts.setting]:append(next_value)
        end
        vim.notify(string.format("%s=%s", opts.setting, vim.o[opts.setting]), vim.log.levels.INFO)
    elseif type(opts.source) == "string" then
        local tbl = get_vim_var(opts.source)
        if old_value then
            for k, v in ipairs(tbl) do
                if v == old_value then
                    table.remove(tbl, k)
                    break
                end
            end
        end
        if next_value ~= "" then
            table.insert(tbl, next_value)
        end
        set_vim_var(opts.source, tbl)
    end

    if opts.callback then
        opts.callback(next_value, old_value)
    end
end

function M.toggle(arg)
    -- create a toggle function that will
    -- toggle a setting over list of available values
    --
    -- arg : string or table
    --   string : effectively { "setting": <value> }
    --   table : {
    --       'setting' : toggle on this vim setting
    --          - string  : name of setting
    --          - table   : Option type returned from vim.opt[name]
    --
    --       'source' : toggle on any other type, ignored if 'setting' present
    --          - string: "g:variable" or "b:variable"
    --          - function: return the current value, in this case 'callback' is recommended
    --          - any: the current value, but should be used in conjunction with 'handler' and/or 'callback'
    --
    --       'choices' : table or function()
    --          - table    : an array of choices to cycle over, if omitted defaults = {true, false}
    --                       list-style options are supported
    --                       set the last element as "" to remove it from toggle list
    --
    --          - function : called before toggle,
    --                       must return a table array of possible choices
    --
    --       'handler'    : function(current_value)
    --                       called before setting, must return the next value
    --                       or `handler_ignore` to not continue 
    --                       (useful when setting the value yourself)
    --
    --       'handler_ignore' : any, default = nil
    --                       don't set the value if handler returns this
    --
    --       'callback'   : function(next_value) for simple types
    --                      function(next_value, old_value) for tabluar types
    --                      called after setting
    --   }
    local opts
    if type(arg) == "string" then
        opts = { setting = arg }
    elseif type(arg) == "table" then
        -- allow from vim.opt
        if arg._name and arg._info then
            opts = { setting = arg._name }
        else
            opts = arg
        end
    else
        error("wrong argument type to toggler. expecting string or table")
    end

    if not opts.choices then
        opts.choices = { true, false }
    end

    return function()
        local current
        if opts.setting then
            current = vim.opt[opts.setting]:get()
        elseif type(opts.source) == "function" then
            current = opts.source()
        elseif type(opts.source) == "string" then
            current = get_vim_var(opts.source)
        else
            current = opts.source
        end

        local choices = type(opts.choices) == "function" and opts.choices() or opts.choices

        if vim.tbl_islist(current) then     -- list-style settings
            -- find the current item from choices
            local found = vim.tbl_filter(function(item)
                for _, v in ipairs(choices) do
                    if v == item then
                        return true
                    end
                end
            end, current)

            if #found > 1 then
                -- something else might have set the setting
                vim.notify(
                    string.format("multiple choices found (%s) in toggle list", table.concat(found, ", ")),
                    vim.log.levels.ERROR
                )
                return
            elseif #found == 1 then
                -- find the next item, remove current and add next
                local next_value = find_next_choice(opts, found[1], choices)
                set_list_next(opts, next_value, found[1])
            else
                -- nothing found, assume first
                set_list_next(opts, choices[1])
            end
            vim.notify(string.format("%s=%s", opts.setting, vim.o[opts.setting]), vim.log.levels.INFO)
        else
            -- single setting
            local next_value = find_next_choice(opts, current, choices)
            set_next(opts, next_value)
        end
    end
end


return M
