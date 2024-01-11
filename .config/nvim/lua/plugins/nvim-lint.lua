return {
    "mfussenegger/nvim-lint",

    event = {
        "BufReadPre",
        "BufNewFile",
    },

    config = function()
        local lint = require('lint')
        lint.linters_by_ft = {
            python = {'mypy', 'flake8'},
            cpp = {'cppcheck'},
            javascript = {'eslint'},
            lua = {'selene'},
        }

        local flake8 = lint.linters.flake8
        table.insert(flake8.args, "--ignore=E501,E731,W391,F403,W292")

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })
    end,

    keys = {
        -- \ll = lint
        { "<leader>ll", function()
            require('lint').try_lint()
        end }
    }
}
