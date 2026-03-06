
-- add support for dmypy
-- dmypy start -- --config-file pyproject.toml --show-column-numbers --show-error-end --hide-error-codes --hide-error-context --no-color-output --no-error-summary --no-pretty
-- dmypy check <filename>
-- dmypy status 

return {
    -- 'feakuru/mypy.nvim',
    'mypy.nvim',
    dir = "/Users/richard.french/Software/mypy.nvim",

    config = function()
        require('mypy').setup({
            -- '--strict', 
            extra_args = {'--config-file', 'pyproject.toml'},
            enabled = false,
        })
    end,
}
