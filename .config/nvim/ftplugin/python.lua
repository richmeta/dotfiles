local mp = require("user.map")
local clipboard = require("user.clip")
local git = require("user.git")
local buffer = require("user.buffer")
local util = require("user.util")

-- buffer local
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

--  notes:  \@<! is positive lookbehind, so only matches when not preceded with quotes

-- switch defs
vim.b.switch_custom_definitions =
    {
      {
          -- kwargs and dict  {key='value'} => {'key': 'value'}
          [ [[\(\k\+\)\s*=\s*\([^),]\+\)]] ] = [["\1": \2]],

          -- kwargs and dict  {'key': 'value'} => {key='value'}
          [ [[[''"]\(\k\+\)[''"]\s*:\s*\([^},]\+\)]] ] = [[\1=\2]],

          -- import \k+ => from \k import
          [ [[^import\s\+\(\k\+\)]] ] = [[from \1 import ]],

          -- from \k import => import \k+
          [ [[^from\s\+\(\k\+\)\s\+import\s.*$]] ] = [[import \1]],

          -- something => _something
          [ [["\@<!\<\(\w*\)\>]] ] = '_\1',

          -- _something => something
          [ [["\@<!\<_\(\w*\)\>]] ] = '\1',

          -- "string" to f"string"
          [ [[f\(".\{-}"\)]] ] = [[\1]],

          -- "string" to f"string"
          [ [[\(".\{-}"\)]] ] = [[f\1]],

      }
    }

-- \dp = remove pdb
mp.nnoremap("<Leader>dp", [[:%g/set_trace\(\)/d<cr>]], mp.buffer)

local function black_format(visual)
    local pos = vim.api.nvim_win_get_cursor(0)
    local cmd = 'black -q'
    if vim.g.black_options ~= nil then
        cmd = string.format("%s %s", cmd, vim.g.black_options)
    end

    local exec
    if visual then
        exec = string.format(":'<,'>!%s - ", cmd)
    else
        exec = string.format(":%%!%s - ", cmd)
    end
    vim.cmd(exec)

    -- reset position
    vim.api.nvim_win_set_cursor(0, pos)
end


if vim.fn.executable('black') then
    mp.nnoremap("<Leader>pf", black_format, mp.buffer)
    mp.vnoremap("<Leader>pf", function()
        black_format(true)
    end, mp.buffer)
end

if vim.fn.executable('ruff') then
    mp.nnoremap("<Leader>rf", function()
        local exec = string.format(":!ruff check --fix-only -q %s && ruff format -q ", vim.fn.expand("%"))
        vim.cmd(exec, { silent = true} )
        vim.cmd(":edit")
    end, mp.buffer)
end

local function pyinfo_find_symbol_clip(return_as)
    local pyinfo_find_symbol = vim.fn["pyinfo#find_symbol"]
    local result = pyinfo_find_symbol(return_as)
    if string.len(result) > 0 then
        clipboard.copy(result)
        vim.notify("copied", vim.log.levels.INFO)
    else
        vim.notify("not found", vim.log.levels.WARN)
    end
end

-- \cy = copy python import of current symbol
mp.nnoremap("<Leader>cy", function()
    pyinfo_find_symbol_clip("import")
end, mp.buffer)

-- \cY = copy python star import of current symbol
mp.nnoremap("<Leader>cY", function()
    pyinfo_find_symbol_clip("starimport")
end, mp.buffer)

-- \cp = copy python path of current symbol
mp.nnoremap("<Leader>cp", function()
    pyinfo_find_symbol_clip("pypath")
end, mp.buffer)

-- \cP = copy file path of current symbol
mp.nnoremap("<Leader>cP", function()
    pyinfo_find_symbol_clip("path")
end, mp.buffer)

-- \ct = copy test spec of current symbol
-- pytest <filename> -k func
mp.nnoremap("<Leader>ct", function()
    local filepath = git.relative_from_buffer(buffer.expand("current"))
    local func = util.expand("<cword>", true)
    local result
    if func == '' then
        result = string.format("pytest %s", filepath)
    else
        result = string.format("pytest %s -k %s", filepath, func)
    end
    clipboard.copy(result)
    vim.notify("copied", vim.log.levels.INFO)
end, mp.buffer)

mp.nnoremap("<Leader>cl", function()
    -- \cl = copy filename:line format
    local line = vim.fn.line(".")
    local path = git.relative_from_buffer(buffer.expand("current"))
    local result = string.format("%s:%d", path, line)
    clipboard.copy(result)
    vim.notify("copied", vim.log.levels.INFO)
end, mp.buffer)

vim.cmd("abbr <buffer> true True")
vim.cmd("abbr <buffer> false False")

