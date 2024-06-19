local mp = require("user.map")
local util = require("user.util")
local file = require("user.file")
local Path = require("plenary.path")

local silent = { silent = true }

local function refresh()
    vim.schedule(function()
        -- refresh
        vim.cmd("Dirvish")
    end)
end

local function cfile()
    return file.strip_trailing(util.expand("<cfile>"), "/$")
end

local function dir()
    return file.strip_trailing(util.expand("%"), "/$")
end

local function copy()
    -- yy yank file
    vim.g.dirvish_file = cfile()
    if vim.g.dirvish_file == nil then
        vim.notify("error", vim.log.levels.INFO)
    else
        vim.notify("yanked", vim.log.levels.INFO)
    end
end

local function rm()
    -- dd delete file
    local path = Path:new(cfile())
    if path:is_dir() then
        file.delete_directory(path)
    elseif path:is_file() then
        file.delete(path)
    end
    vim.notify(string.format("deleted %s", tostring(path)), vim.log.levels.INFO)
    refresh()
end

local function put(move)
    -- p(copy) or P(move) file or dir
    if vim.g.dirvish_file == nil then
        vim.notify("nothing in yank register", vim.log.levels.ERROR)
        return
    end
    local success = nil
    local source = Path:new(vim.g.dirvish_file)
    local target = Path:new(string.format("%s/%s", dir(), file.filename(vim.g.dirvish_file)))

    if file.path_equal(source, target) then
        vim.notify("source and target the same", vim.log.levels.ERROR)
        return
    end

    if move == true and not target:exists() then
        -- simple rename
        source:rename({ new_name = tostring(target) })
        success = "moved"
    else
        local cp_opts = {
            interactive = true,
            destination = target
        }
        if source:is_dir() then
            cp_opts.recursive = true
        elseif not source:is_file() then
            vim.notify("cannot copy not a file or directory", vim.log.levels.ERROR)
            return
        end
        local result = source:copy(cp_opts)
        for key, val in pairs(result) do
            if val == false then
                vim.notify(string.format("failed to copy: %s", key), vim.log.levels.ERROR)
                return
            end
        end
        if move == true then
            source:rm({ recursive = source:is_dir() })
            success = "moved"
        else
            success = "copied"
        end
    end

    if success then
        refresh()
        vim.notify(string.format("%s to %s", success, tostring(target)), vim.log.levels.INFO)
    end
end

mp.nnoremap_b("<Esc>", "<Plug>(dirvish_quit)")


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
mp.nmap_b("md", [[:!mkdir -p %/]])

-- rd = rmdir (dirvish)
mp.nmap_b("rd", function()
    local cmd = string.format("!rmdir %s", cfile())
    util.execute(cmd)
end)

-- yy = yank the file (dirvish)
mp.nmap_b("yy", copy)

-- p = put copy the file (dirvish)
mp.nmap_b("p", put)

-- dd = delete file or dir (dirvish)
mp.nmap_b("dd", rm)

-- P = put move the file (dirvish)
mp.nmap_b("P", function()
    put(true)
end)

-- cw = rename file
mp.nmap_b("cw", function()
    file.prompt_rename(cfile())
end)

-- ne = new file
mp.nmap_b("ne", [[:e %/]])

-- v = vertical split (dirvish)
mp.nmap_b("v", "a", { remap = true})

-- s = horiz split (dirvish)
mp.nmap_b("s", "o", { remap = true})

-- ctrl-t = open in tab (dirvish)
mp.nmap_b("<C-t>", "t", { remap = true})

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

-- h = up dir (dirvish) [like vifm]
mp.nmap_b("h", "<Plug>(dirvish_up):echo(expand('%'))<cr>", silent)

-- copypath
mp.nmap_b("<Leader>cd", function()
    file.clip({ typ = "dir", showmsg = true })
end,
silent)

mp.nmap_b("<Leader>cf", function()
    file.clip({ typ = "full", showmsg = true })
end,
silent)

mp.nmap_b("<Leader>cv", function()
    file.clip({ typ = "filename", showmsg = true })
end,
silent)

mp.nmap_b("<Leader>cs", function()
    file.clip({ typ = "stem", showmsg = true })
end,
silent)

-- \cg = copy git path relative
mp.nmap_b("<Leader>cg", function()
    file.clip({ typ = "git", showmsg = true })
end)

