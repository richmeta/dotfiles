return {
    "folke/trouble.nvim",

    opts = {}, -- required to setup commands

     keys = {
        -- \tg = TroubleToggle
        { "<leader>tg", ":Trouble diagnostics toggle filter.buf=0<cr>", mode = "n", noremap = true },
    }
}
