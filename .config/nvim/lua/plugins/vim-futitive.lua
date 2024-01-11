
return {
    "tpope/vim-fugitive",

    lazy = false, 

    keys = {
        -- \gd = Gvdiff
        { "<leader>gd", ":Gvdiff<cr>", mode = "n", noremap = true },

        -- <leader>gs = Gstatus
        { "<Leader>gs", ":Git<cr>", mode = "n", noremap = true },

        -- <leader>gb = Gblame<cr>
        { "<Leader>gb", ":Git blame<cr>", mode = "n", noremap = true },

        -- <leader>gR = Gread<cr>
        { "<Leader>gR", ':Gread<bar>echo "git checkout -f"<cr>', mode = "n", noremap = true },
    }

}
