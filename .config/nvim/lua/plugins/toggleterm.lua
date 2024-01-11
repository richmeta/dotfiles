return {
    "akinsho/toggleterm.nvim",

    opts = {
        -- ctrl-b = open toggleterm
        open_mapping = "<m-t>",
        start_in_insert = true,
        insert_mappings = true,
        direction = "vertical",
        persist_size = false,
        size = function()
            return vim.o.columns * 0.4
        end,
    }
}
