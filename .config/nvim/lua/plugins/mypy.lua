
-- add support for dmypy
-- dmypy start -- --config-file pyproject.toml --show-column-numbers --show-error-end --hide-error-codes --hide-error-context --no-color-output --no-error-summary --no-pretty
-- dmypy check <filename>
-- dmypy status 

return {
    'richmeta/mypy.nvim',

    branch = 'dmypy',

    config = function()
        require('mypy').setup({
            extra_args = {'--config-file', 'pyproject.toml'},
            enabled = true,
        })
    end,
}
