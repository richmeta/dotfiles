local file = require('user.file')
local util = require('user.util')
local executable = vim.fn.executable


return {
    "mfussenegger/nvim-lint",

    event = {
        "BufReadPre",
        "BufNewFile",
    },

    config = function()
        local lint = require('lint')
        lint.linters_by_ft = {}

        local desired = {
            python = {'mypy', 'flake8', 'ruff'},
            cpp = {'cppcheck'},
            javascript = {'eslint'},
        }

        -- only insert if executable
        for lang, linters in pairs(desired) do
            for _, linter in pairs(linters) do
                if executable(linter) == 1 then
                    if not lint.linters_by_ft[lang] then
                        lint.linters_by_ft[lang] = {}
                    end
                    table.insert(lint.linters_by_ft[lang], linter)
                end
            end
        end

        -- -- flake8
        if lint.linters_by_ft.python then
            if util.has_value(lint.linters_by_ft.python, "flake8") then
                local flake8 = lint.linters.flake8
                table.insert(flake8.args, "--ignore=E501,E731,W391,F403,W292")
            end

            -- mypy
            if util.has_value(lint.linters_by_ft.python, "mypy") then
                local mypy_config = file.any_exists({"mypy.ini", ".mypy.ini", "pyproject.toml"})
                if mypy_config ~= nil then
                    local mypy = lint.linters.mypy
                    table.insert(mypy.args, "--config-file="..mypy_config)
                end
            end
        end

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                if vim.b.lint_enabled ~= false then
                    lint.try_lint()
                end
            end,
        })
    end,

    keys = {
        -- \lt = lint toggle
        { "<leader>lt", function()
            if vim.b.lint_enabled == nil then
                vim.b.lint_enabled = false
            else
                vim.b.lint_enabled = not vim.b.lint_enabled
            end
            local label = vim.b.lint_enabled and "enabled" or "disabled"
            vim.notify("lint " .. label, vim.log.levels.INFO)
        end }
    }
}
