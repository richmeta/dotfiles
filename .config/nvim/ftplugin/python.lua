local mp = require("user.map")

-- buffer local
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

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
      }
    }

-- \dp = remove pdb
mp.nnoremap("<Leader>dp", [[:%g/set_trace\(\)/d<cr>]], mp.buffer)

if vim.fn.executable('black') then
    mp.nnoremap("<Leader>pf", ":%!black -q - <cr><cr>")
    mp.vnoremap("<Leader>pf", ":!black -q - <cr><cr>")
end
