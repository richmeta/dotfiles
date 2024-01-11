local mp = require("user.map")

vim.api.nvim_create_autocmd({"TermOpen"}, {
    pattern = "term://*",
    callback = function()
        mp.tnoremap_b("<c-h>", [[<C-\><C-n><C-w>h]])
        mp.tnoremap_b("<c-j>", [[<C-\><C-n><C-w>j]])
        mp.tnoremap_b("<c-k>", [[<C-\><C-n><C-w>k]])
        mp.tnoremap_b("<c-l>", [[<C-\><C-n><C-w>l]])
    end,
})
