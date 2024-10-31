return {
    "williamboman/mason-lspconfig.nvim",

    opts = {
        ensure_installed = {
            "clangd",
            "docker_compose_language_service",
            "lua_ls",
            "gopls",
            "pyright",
            "rust_analyzer",
            "ts_ls",
            "yamlls",
            "zls",
        }
    }
}
