
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

        -- <leader>gp = Git pull
        { "<Leader>gp", ':Git pull<cr>', mode = "n", noremap = true },

        -- <leader>gu = Git push
        { "<Leader>gu", ':Git push<cr>', mode = "n", noremap = true },

        -- <leader>gt = Git stash
        { "<Leader>gt", ':Git stash<cr>', mode = "n", noremap = true },

        -- <leader>go = Git stash pop
        { "<Leader>gO", ':Git stash pop<cr>', mode = "n", noremap = true },
    }

}
