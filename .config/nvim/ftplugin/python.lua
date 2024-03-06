local mp = require("user.map")
local clipboard = require("user.clip")

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
          [ [[import\s\+\(\k\+\)]] ] = [[from \1 import ]],

          -- from \k import => import \k+
          [ [[from\s\+\(\k\+\)\s\+import\s.*$]] ] = [[import \1]],

          -- something => _something
          [ [["\@<!\<\(\w*\)\>]] ] = '_\1',

          -- _something => something
          [ [["\@<!\<_\(\w*\)\>]] ] = '\1',
      }
    }

-- \dp = remove pdb
mp.nnoremap("<Leader>dp", [[:%g/set_trace\(\)/d<cr>]], mp.buffer)

if vim.fn.executable('black') then
    mp.nnoremap("<Leader>pf", ":%!black -q - <cr><cr>")
    mp.vnoremap("<Leader>pf", ":!black -q - <cr><cr>")
end

local function pyinfo_find_symbol_clip(return_as)
    local pyinfo_find_symbol = vim.fn["pyinfo#find_symbol"]
    local result = pyinfo_find_symbol(return_as)
    clipboard.copy(result)
end

-- \cy = copy python path of current symbol
mp.nnoremap("<Leader>cy", function()
    pyinfo_find_symbol_clip("pypath")
end, mp.buffer)

-- \cp = copy file path of current symbol
mp.nnoremap("<Leader>cp", function()
    pyinfo_find_symbol_clip("path")
end, mp.buffer)


