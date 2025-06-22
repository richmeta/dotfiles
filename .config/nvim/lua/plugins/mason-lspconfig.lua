-- load any local plugins, from user/localmason-lspconfig.lua
-- eg return { "lsp1", "lsp2", ... }
local ok, local_extra_installed = pcall(require, 'local.mason-lspconfig')
if not ok then
    local_extra_installed = {}
end

local ensure_installed = {
    "clangd",
    "docker_compose_language_service",
    "gopls",
    "jedi_language_server",
    "lua_ls",
    "rust_analyzer",
    "ts_ls",
    "yamlls",
    "zls",
    -- "postgres_lsp", # TODO: add to local
}
vim.list_extend(ensure_installed, local_extra_installed)

return {
    "williamboman/mason-lspconfig.nvim",

    opts = {
        ensure_installed = ensure_installed,
        automatic_enable = false,
    }
}
