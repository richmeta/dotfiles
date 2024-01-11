local mp = require("user.map")
local util = require("user.util")
local file = require("user.file")

local silent = { silent = true }

local function cfile()
    return util.expand("<cfile>")
end

local function dir()
    return util.expand("%")
end

mp.nnoremap_b("<Esc>", "<Plug>(dirvish_quit)")

mp.nmap_b("<c-t>", "t")

-- wd = cd (dirvish)
mp.nnoremap_b("<Leader>wd", function()
    util.execute("cd ", util.expand("%:h"))
    util.execute("pwd")
end)

-- \pd = print directory name
mp.nmap_b("<leader>pd", function()
    vim.notify(dir(), vim.log.levels.INFO)
end)

-- md = mkdir (dirvish)
mp.nmap_b("md", [[:!mkdir %/]])

-- rd = rmdir (dirvish)
mp.nmap_b("rd", function()
    local cmd = string.format("!rmdir %s", cfile())
    util.execute(cmd)
end)

-- helpers for cp / mv
vim.api.nvim_buf_create_user_command(0, "Cp", [[:!cp "<cfile>"<space><args>]], { nargs = 1, complete = "file" })
vim.api.nvim_buf_create_user_command(0, "Mv", [[:!mv "<cfile>"<space><args>]], { nargs = 1, complete = "file" })

-- cp = copy file under cursor (dirvish)
mp.nmap_b("cp", ":Cp<space>%/")

-- mv = move file under cursor (dirvish)
mp.nmap_b("mv", ":Mv<space>%/")

-- cw = rename file
mp.nmap_b("cw", function()
    file.prompt_rename(cfile())
end)
mp.nmap_b("rn", "cw")

-- rm = delete file under cursor (dirvish)
mp.nnoremap_b("rm", function()
    local filename = cfile()
    local msg = string.format("remove file '%s'?: ", filename)
    vim.ui.input({ prompt = msg }, function(value)
        if value == "y" or value == "Y" then
            local cmd = string.format('!rm "%s"', filename)
            util.execute(cmd)
        else
            vim.notify("not deleted", vim.log.levels.INFO)
        end
    end)
end)
mp.nmap_b("<Leader>rm", "rm")

-- ne = new file
mp.nmap_b("ne", [[:e %/]])

-- v = vertical split (dirvish)
mp.nmap_b("v", "a", { remap = true})

-- s = horiz split (dirvish)
mp.nmap_b("s", "o", { remap = true})

-- ctrl-t = open in tab (dirvish)
mp.nmap_b("<C-T>", "t", { remap = true})

-- open file under cursor in new tab (dirvish)
mp.nnoremap_b("t", ":call dirvish#open('tabedit', 0)<cr>", silent)
mp.xnoremap_b("t", ":call dirvish#open('tabedit', 0)<cr>", silent)

local function open()
    local dirvish_open = vim.fn["dirvish#open"]
    dirvish_open("edit", 0)
    vim.notify(dir(), vim.log.levels.INFO)
end

-- cr = open (dirvish) file under cursor (no split)
-- l = open (dirvish) [like vifm]
mp.nmap_b("<cr>", open, { nowait = true, silent = true })
mp.nmap_b("l", open, { nowait = true, silent = true })

-- r-click = preview
mp.nmap_b("<RightMouse>", "p")

-- h = up dir (dirvish) [like vifm]
mp.nmap_b("h", "<Plug>(dirvish_up)", silent)

-- copypath
mp.nmap_b("<Leader>cd", function()
    file.clip({ typ = "dir" })
end,
silent)

mp.nmap_b("<Leader>cf", function()
    file.clip({ typ = "full" })
end,
silent)

mp.nmap_b("<Leader>cv", function()
    file.clip({ typ = "filename" })
end,
silent)

mp.nmap_b("<Leader>cs", function()
    file.clip({ typ = "stem" })
end,
silent)
