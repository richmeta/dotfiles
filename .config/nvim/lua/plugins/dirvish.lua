local git = require("user.git")
local mp = require("user.map")
local fn = mp.fn_term

return {
    "justinmk/vim-dirvish",

    lazy = false,

    keys = {
        -- <F4> = dirvish current dir
        { "<F4>", "<Plug>(dirvish_up):echo(expand('%'))<cr>", mode = "n", noremap = true },
        { "<F4>", "Dirvish<Space>", mode = "c" },

        -- g<F4> = dirvish git root dir
        { "g<F4>", function()
            local gitdir = git.root()
            if gitdir then
                local cmd = string.format("Dirvish %s", gitdir)
                vim.cmd(cmd)
            end
        end, mode = "n" },

        -- Shift-<F4> = vsplit + dirvish current dir
        { fn("<S-F4>"), "<Plug>(dirvish_vsplit_up)", mode = "n", noremap = true },

        -- \F4 = dirvish from this directory or file (tab)
        { "<leader><F4>", function()
            vim.cmd(string.format("tabedit +Dirvish %s", vim.fn.expand('%', 'dir')))
        end, mode = "n" },

        -- \g<F4> = dirvish git root dir (newtab)
        { fn("<leader>g<F4>"), function()
            local gitdir = git.root()
            if gitdir then
                vim.cmd(string.format("tabedit +Dirvish %s", gitdir))
            end
          end, mode = "n" }
    }
}
