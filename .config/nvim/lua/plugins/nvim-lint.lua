local file = require('user.file')
local util = require('user.util')
local executable = vim.fn.executable

local defaults = {
    python = {'flake8', 'ruff'},
    cpp = {'cppcheck'},
    javascript = {'eslint'},
}

-- per project linting (overrides defaults)
--  let g:desired_linters = { "python": ["dmypy" | "mypy", "ruff"] }
--  let g:desired_linters_options = { "python": {"mypy": "--config-file X"} }

-- attempting to add dmypy
local function add_dmypy(lint)
    lint.linters.dmypy = {
        cmd = 'dmypy',
        stdin = false,
        args = {"check"},
        stream = "stdout",
        ignore_exitcode = true,
        ignore_errors = false,
        parser = vim.deepcopy(lint.linters.mypy.parser)
    }
end

local function start_dmypy() 
    -- todo: check if running and start if not
    -- dmypy start --log-file=dmypy.log -- --config-file pyproject.toml --show-column-numbers --show-error-end --hide-error-codes --hide-error-context --no-color-output --no-error-summary --no-pretty --python-executable=/Users/richard.french/Library/Caches/pypoetry/virtualenvs/data-rest-api-MLb99vsf-py3.12/bin/python3
end

return {
    "mfussenegger/nvim-lint",

    enabled = true,

    event = {
        "BufReadPre",
        "BufNewFile",
    },

    config = function()
        local lint = require('lint')
        lint.linters_by_ft = {}

        local desired = vim.g.desired_linters or defaults

        -- only insert if executable
        for lang, linters in pairs(desired) do
            for _, linter in pairs(linters) do
                if linter == "dmypy" then
                    add_dmypy(lint)
                end
                if executable(linter) == 1 then
                    if not lint.linters_by_ft[lang] then
                        lint.linters_by_ft[lang] = {}
                    end
                    table.insert(lint.linters_by_ft[lang], linter)
                else
                    -- warning if not found from g:desired_linters
                    if vim.g.desired_linters ~= nil then
                        vim.notify("linter " .. linter .. " not found", vim.log.levels.WARN)
                    end
                end
            end
        end

        local has_flake8 = util.has_value(lint.linters_by_ft.python, "flake8")
        local has_mypy = util.has_value(lint.linters_by_ft.python, "mypy")
        -- local has_dmypy = util.has_value(lint.linters_by_ft.python, "dmypy")

        if lint.linters_by_ft.python then
            if has_flake8 then
                local flake8 = lint.linters.flake8
                table.insert(flake8.args, "--ignore=E501,E704,E731,W391,F403,W292")
            end

            if has_mypy then
                local mypy_config = file.any_exists({"mypy.ini", ".mypy.ini", "pyproject.toml"})
                if mypy_config ~= nil then
                    local mypy = lint.linters.mypy
                    table.insert(mypy.args, "--config-file="..mypy_config)
                end
            end
        end

        -- add any custom args
        if vim.g.desired_linters_options ~= nil then
            for _, options in pairs(vim.g.desired_linters_options) do
                for name, args in pairs(options) do
                    local linter_cfg = lint.linters[name]
                    table.insert(linter_cfg.args, args)
                end
            end
        end

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

        local events = { "BufEnter", "BufWritePost", "InsertLeave" }
        if has_mypy then
            -- mypy is slow
            events = {"BufWritePost"}
        end

        vim.api.nvim_create_autocmd(events, {
            group = lint_augroup,
            callback = function(ev)
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
