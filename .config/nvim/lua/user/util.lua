local M = {}

-- nice reloading of modules
local plenary_ok, plenary_reload = pcall(require, "plenary.reload")
local reloader = require
if plenary_ok then
  reloader = plenary_reload.reload_module
end

-- GLOBALs!
P = function(v)     --ignore
  print(vim.inspect(v))
  return v
end

RELOAD = function(...)
  return reloader(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

--

function M.fif(condition, when_true, when_false)
    -- equiv of ternary
    if condition then
        return when_true
    else
        return when_false
    end
end

function M.debug(...)
    if vim.g.show_debug then
        local arg={...}
        local msg = ""
        for _, v in ipairs(arg) do
            msg = msg .. tostring(v)
        end
        print(msg)  -- as echom
    end
end

function M.execute(...)
    local arg={...}
    local cmd = ""
    for _, v in ipairs(arg) do
        cmd = cmd .. v
    end
    M.debug("running cmd: ", cmd)
    vim.cmd(cmd)
end

function M.expand(arg)
    local value = vim.fn.expand(arg)
    if value == nil or value == "" then
        error("expand("..arg..") is empty")
    end
    return value
end

-- catch vim error code and print message
function M.safe_call(func, ...)
    local ok, res = pcall(func, ...)
    if ok then
        return res
    else
        vim.notify(res, vim.log.levels.ERROR)
        return nil
    end
end


function M.ex(cmdline, immediate)
    -- run an excommand
    -- cmdline can be a single or table of cmds
    local run =
        function()
            if type(cmdline) == "string" then
                M.safe_call(vim.api.nvim_command, cmdline)
            elseif type(cmdline) == "table" then
                for _, cmd in ipairs(cmdline) do
                    M.safe_call(vim.api.nvim_command, cmd)
                end
            end
        end

    if immediate then
        -- run now
        run()
    else
        -- return wrapper (for keymaps)
        return run
    end
end

-- inserts `value` at current cursor pos
function M.insert_text(value)
    if not value or #value == 0 then
        return
    end
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_text(0, pos[1]-1, pos[2], pos[1]-1, pos[2], { value })
    vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + string.len(value) })
end

function M.len(T)
    if type(T) == "table" then
        local count = 0
        for _ in pairs(T) do
            count = count + 1
        end
        return count
    elseif type(T) == "string" then
        return T:len()
    else
        error("bad type")
    end
end

function M.isempty(T)
    if type(T) == "table" then
        return not T or not next(T)
    elseif type(T) == "string" then
        return T == ""
    else
        error("bad type")
    end
end

return M
