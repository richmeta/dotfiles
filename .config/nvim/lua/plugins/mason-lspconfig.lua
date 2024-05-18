return {
    "williamboman/mason-lspconfig.nvim",

    opts = {
        ensure_installed = {
            "clangd",
            "docker_compose_language_service",
            "lua_ls",
            "pyright",
            "rust_analyzer",
            "tsserver",
            "yamlls",
        }
    }
}
