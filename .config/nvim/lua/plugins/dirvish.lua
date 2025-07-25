local git = require("user.git")
local mp = require("user.map")
local fn = mp.fn_term

return {
    "justinmk/vim-dirvish",

    lazy = false,

    config = function()
        -- sort dirs first
        -- unfortunately this ignores wildignore
        vim.g.dirvish_mode = ":sort ,^.*/,"
    end,

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
            local cmd
            if vim.o.filetype == 'dirvish' then
                local fname = vim.fn.expand("<cfile>")
                local realpath = vim.fn.trim(vim.fn.system('readlink ' .. vim.fn.fnameescape(fname)))
                if realpath == '' then
                    -- normal file
                    cmd = 'tabedit +Dirvish ' .. vim.fn.fnameescape(fname)
                else
                    cmd = 'tabedit +Dirvish ' .. vim.fn.fnameescape(realpath)
                end
            else
                cmd = 'tabedit +Dirvish ' .. vim.fn.fnameescape(vim.fn.expand("%:p"))
            end
            vim.cmd(cmd)
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
