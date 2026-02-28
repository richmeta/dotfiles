return {
    "stevearc/conform.nvim",

    opts = {
        formatters_by_ft = {
            python = { "ruff_format", "ruff_organize_imports" },
            rust = { "rustfmt", lsp_format = "fallback" },
        }
    },

    keys = {
        -- ruff organise imports
        { "<leader>ri", function()
            require("conform").format({
                formatters = { "ruff_organize_imports" }
            })
        end, mode = "n" },
    }
}
