local mp = require("user.map")

vim.opt_local.iskeyword:append ":" 

-- \so = source file
mp.nnoremap("<Leader>so", ":source %<cr>", mp.buffer)
