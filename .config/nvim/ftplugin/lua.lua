local mp = require("user.map")

-- \dp = remove util.debug
mp.nnoremap("<Leader>dp", [[:%g/util.debug\(\)/d<cr>]], mp.buffer)
