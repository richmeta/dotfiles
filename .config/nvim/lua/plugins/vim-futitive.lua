
return {
    "tpope/vim-fugitive",

    lazy = false,

    keys = {
        -- \dv = Gvdiff
        { "<leader>dv", ":Gvdiff<cr>", mode = "n", noremap = true },

        -- <leader>gs = Gstatus
        { "<Leader>gs", ":Git<cr>", mode = "n", noremap = true },

        -- <leader>gb = Gblame
        { "<Leader>gb", ":Git blame<cr>", mode = "n", noremap = true },

        -- <leader>gR = Gread (checkout -f)
        { "<Leader>gR", ':Gread<bar>echo "git checkout -f"<cr>', mode = "n", noremap = true },

        -- <leader>gP = Git pull
        { "<Leader>gP", ':Git pull<cr>', mode = "n", noremap = true },

        -- <leader>gU = Git push
        { "<Leader>gU", ':Git push<cr>', mode = "n", noremap = true },

        -- <leader>gS = Git stash
        { "<Leader>gS", ':Git stash<cr>', mode = "n", noremap = true },

        -- <leader>gO = Git stash pop
        { "<Leader>gO", ':Git stash pop<cr>', mode = "n", noremap = true },
    }

}
