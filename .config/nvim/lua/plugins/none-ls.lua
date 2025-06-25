return {
    "nvimtools/none-ls.nvim",

    config = function() 
        local null_ls = require('null-ls')

        null_ls.setup({
            sources = {
                -- mypy
                -- null_ls.builtins.diagnostics.mypy 

                null_ls.builtins.diagnostics.mypy.with({
                    command = "dmypy",
                    args = function(params)
                        return {
                            "run",
                            "--timeout", "300",
                            "--",
                            "--python-executable", "python3",
                            "--hide-error-codes",
                            "--hide-error-context",
                            "--no-color-output",
                            "--show-absolute-path",
                            "--show-column-numbers",
                            "--show-error-codes",
                            "--no-error-summary",
                            "--no-pretty",
                            params.temp_file, -- dmypy can read from temporary files
                        }
                    end,
                    timeout = 60000,
                    debug = true,
                })

            },
        })
    end
}
