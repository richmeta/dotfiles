
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.pem",
    command = "set filetype=pem",
})
