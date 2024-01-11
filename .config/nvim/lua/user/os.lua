local M = {}

M.is_mac = (vim.fn.has('mac') == 1)
M.home_dir = vim.env.HOME
M.nvim_config_dir = vim.fn.stdpath("config")
M.is_gui = (vim.fn.exists("g:neovide") == 1)
M.is_neovide = (vim.fn.exists("g:neovide") == 1)

return M
